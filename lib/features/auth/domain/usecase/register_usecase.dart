import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart';

/// Single-responsibility use case for user registration.
@lazySingleton
class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String password,
    String? username,
  }) {
    return _repository.register(
      email: email,
      password: password,
      username: username,
    );
  }
}
