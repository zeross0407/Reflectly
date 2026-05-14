import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/features/auth/domain/usecase/login_usecase.dart';
import 'login_event.dart';
import 'login_state.dart';

/// BLoC that handles user login.
@injectable
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginUseCase _loginUseCase;

  LoginBloc({required LoginUseCase loginUseCase})
      : _loginUseCase = loginUseCase,
        super(const LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(const LoginLoading());

    final result = await _loginUseCase(
      email: event.email,
      password: event.password,
    );

    result.fold(
      (failure) => emit(LoginFailure(
        failure.when(
          server: (message, statusCode) => message,
          network: (message) => message,
          unauthorized: (message) => 'Email or password is incorrect.',
          notFound: (message) => message,
          timeout: (message) => message,
          unknown: (message) => message,
          cache: (message) => message,
        ),
      )),
      (session) => emit(LoginSuccess(session)),
    );
  }
}
