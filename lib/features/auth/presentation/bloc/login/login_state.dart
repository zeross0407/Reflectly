import 'package:equatable/equatable.dart';

import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';

/// States for [LoginBloc].
abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

/// Initial idle state.
class LoginInitial extends LoginState {
  const LoginInitial();
}

/// Login request is in progress.
class LoginLoading extends LoginState {
  const LoginLoading();
}

/// Login succeeded — contains the auth session.
class LoginSuccess extends LoginState {
  final AuthSession session;

  const LoginSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

/// Login failed — contains the error message.
class LoginFailure extends LoginState {
  final String message;

  const LoginFailure(this.message);

  @override
  List<Object?> get props => [message];
}
