import 'package:dartz/dartz.dart';
import 'package:myrefectly/core/error/exceptions.dart';
import 'package:myrefectly/core/error/failures.dart';
import 'package:myrefectly/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:myrefectly/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:myrefectly/features/auth/domain/entities/user_entity.dart';
import 'package:myrefectly/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, UserEntity>> login(
      String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      await localDataSource.saveUserData(userModel);
      return Right(userModel);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
