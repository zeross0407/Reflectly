import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/features/auth/domain/usecase/register_usecase.dart';
import 'register_event.dart';
import 'register_state.dart';

@injectable
class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterUseCase _registerUseCase;

  RegisterBloc({required RegisterUseCase registerUseCase})
      : _registerUseCase = registerUseCase,
        super(const RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(const RegisterLoading());

    final result = await _registerUseCase(
      email: event.email,
      password: event.password,
      username: event.username,
    );

    result.fold(
      (failure) => emit(RegisterFailure(
        failure.when(
          server: (message, statusCode) =>
              statusCode == 400 ? 'Account already exists.' : message,
          network: (message) => message,
          unauthorized: (message) => message,
          notFound: (message) => message,
          timeout: (message) => message,
          unknown: (message) => message,
          cache: (message) => message,
        ),
      )),
      (session) => emit(RegisterSuccess(session)),
    );
  }
}
