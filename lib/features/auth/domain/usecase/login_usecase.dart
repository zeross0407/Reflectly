import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart';

/// Single-responsibility use case for user login.
@lazySingleton
class LoginUseCase {
  final AuthRepository _repository;

  const LoginUseCase(this._repository);

  Future<Either<Failure, AuthSession>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
