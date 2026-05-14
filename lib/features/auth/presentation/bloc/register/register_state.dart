import 'package:equatable/equatable.dart';

import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';

abstract class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterLoading extends RegisterState {
  const RegisterLoading();
}

class RegisterSuccess extends RegisterState {
  final AuthSession session;

  const RegisterSuccess(this.session);

  @override
  List<Object?> get props => [session];
}

class RegisterFailure extends RegisterState {
  final String message;

  const RegisterFailure(this.message);

  @override
  List<Object?> get props => [message];
}
