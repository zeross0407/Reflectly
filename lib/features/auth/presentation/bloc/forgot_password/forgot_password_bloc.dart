import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/features/auth/domain/usecase/forgot_password_usecase.dart';
import 'forgot_password_event.dart';
import 'forgot_password_state.dart';

@injectable
class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordBloc({required ForgotPasswordUseCase forgotPasswordUseCase})
      : _forgotPasswordUseCase = forgotPasswordUseCase,
        super(const ForgotPasswordInitial()) {
    on<ResetCodeRequested>(_onResetCodeRequested);
  }

  Future<void> _onResetCodeRequested(
    ResetCodeRequested event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    emit(const ForgotPasswordLoading());

    final result = await _forgotPasswordUseCase(email: event.email);

    result.fold(
      (failure) => emit(ForgotPasswordFailure(
        failure.when(
          server: (message, statusCode) => message,
          network: (message) => message,
          unauthorized: (message) => message,
          notFound: (message) => 'Email not found.',
          timeout: (message) => message,
          unknown: (message) => message,
          cache: (message) => message,
        ),
      )),
      (_) => emit(const ForgotPasswordCodeSent()),
    );
  }
}
