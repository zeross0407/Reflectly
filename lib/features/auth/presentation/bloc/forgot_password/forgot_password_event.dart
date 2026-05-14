import 'package:equatable/equatable.dart';

abstract class ForgotPasswordEvent extends Equatable {
  const ForgotPasswordEvent();

  @override
  List<Object?> get props => [];
}

/// User submitted their email to request a reset code.
class ResetCodeRequested extends ForgotPasswordEvent {
  final String email;

  const ResetCodeRequested({required this.email});

  @override
  List<Object?> get props => [email];
}
