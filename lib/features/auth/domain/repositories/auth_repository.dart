import 'package:dartz/dartz.dart';
import 'package:myrefectly/core/error/failures.dart';
import 'package:myrefectly/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login(String email, String password);
} 