import 'package:dartz/dartz.dart';

import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart';

/// Single-responsibility use case for user logout.
class LogoutUseCase {
  final AuthRepository _repository;

  const LogoutUseCase(this._repository);

  Future<Either<Failure, void>> call() {
    return _repository.logout();
  }
}
