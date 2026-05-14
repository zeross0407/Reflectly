import 'package:equatable/equatable.dart';

abstract class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

/// User tapped the register button.
class RegisterSubmitted extends RegisterEvent {
  final String email;
  final String password;
  final String? username;

  const RegisterSubmitted({
    required this.email,
    required this.password,
    this.username,
  });

  @override
  List<Object?> get props => [email, password, username];
}
