import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:myrefectly/core/error/failures.dart';
import 'package:myrefectly/core/usecases/usecase.dart';
import 'package:myrefectly/features/auth/domain/entities/user_entity.dart';
import 'package:myrefectly/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginParams params) async {
    if (!_isValidEmail(params.email)) {
      return Left(ValidationFailure(
        message: 'Invalid email format',
        field: 'email',
      ));
    }

    if (!_isValidPassword(params.password)) {
      return Left(ValidationFailure(
        message: 'Password must be at least 6 characters long',
        field: 'password',
      ));
    }

    return repository.login(params.email, params.password);
  }

  bool _isValidEmail(String email) {
    final emailRegExp = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');
    return emailRegExp.hasMatch(email);
  }

  bool _isValidPassword(String password) {
    return password.length >= 6;
  }
}

class LoginParams extends Equatable {
  final String email;
  final String password;

  const LoginParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
} 