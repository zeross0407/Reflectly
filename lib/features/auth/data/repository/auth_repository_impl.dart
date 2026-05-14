import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/core/network/connectivity/network_info.dart';
import 'package:myrefectly/core/network/interceptors/error_interceptor.dart';
import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/core/network/token/token_manager.dart';
import 'package:myrefectly/features/auth/data/datasource/auth_remote_datasource.dart';
import 'package:myrefectly/features/auth/data/model/login_request_model.dart';
import 'package:myrefectly/features/auth/data/model/register_request_model.dart';
import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';
import 'package:myrefectly/features/auth/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final NetworkInfo _networkInfo;
  final TokenManager _tokenManager;

  const AuthRepositoryImpl({
    required AuthRemoteDataSource dataSource,
    required NetworkInfo networkInfo,
    required TokenManager tokenManager,
  })  : _dataSource = dataSource,
        _networkInfo = networkInfo,
        _tokenManager = tokenManager;

  @override
  Future<Either<Failure, AuthSession>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        Failure.network(message: 'No internet connection.'),
      );
    }

    try {
      final response = await _dataSource.login(
        LoginRequestModel(email: email, password: password),
      );

      // Persist tokens for subsequent authenticated requests
      await _tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, AuthSession>> register({
    required String email,
    required String password,
    String? username,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        Failure.network(message: 'No internet connection.'),
      );
    }

    try {
      final response = await _dataSource.register(
        RegisterRequestModel(
          email: email,
          password: password,
          data: username != null ? {'username': username} : null,
        ),
      );

      await _tokenManager.saveTokens(
        accessToken: response.accessToken,
        refreshToken: response.refreshToken,
      );

      return Right(response.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset({
    required String email,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        Failure.network(message: 'No internet connection.'),
      );
    }

    try {
      await _dataSource.requestPasswordReset({'email': email});
      return const Right(null);
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    if (!await _networkInfo.isConnected) {
      // Even without network, clear local tokens
      await _tokenManager.clearTokens();
      return const Right(null);
    }

    try {
      await _dataSource.logout();
      await _tokenManager.clearTokens();
      return const Right(null);
    } on DioException catch (e) {
      // Clear tokens even if logout API call fails
      await _tokenManager.clearTokens();
      return Left(e.toFailure());
    }
  }

  @override
  Future<Either<Failure, AuthUser>> getCurrentUser() async {
    if (!await _networkInfo.isConnected) {
      return const Left(
        Failure.network(message: 'No internet connection.'),
      );
    }

    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(e.toFailure());
    }
  }
}
