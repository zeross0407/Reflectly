import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart';

/// Single-responsibility use case for requesting a password reset email.
@lazySingleton
class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({required String email}) {
    return _repository.requestPasswordReset(email: email);
  }
}
