import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:myrefectly/features/auth/data/model/auth_response_model.dart';
import 'package:myrefectly/features/auth/data/model/login_request_model.dart';
import 'package:myrefectly/features/auth/data/model/register_request_model.dart';

part 'auth_remote_datasource.g.dart';

/// Retrofit interface for Supabase GoTrue REST API.
///
/// All endpoints are relative to the Supabase project URL
/// (e.g. `https://xxxx.supabase.co`).
///
/// The `apikey` header is injected via [DioConfig.extraHeaders].
/// The `Authorization` header is injected via [AuthInterceptor].
@RestApi()
abstract class AuthRemoteDataSource {
  factory AuthRemoteDataSource(Dio dio, {String? baseUrl}) =
      _AuthRemoteDataSource;

  /// Sign in with email + password.
  ///
  /// Returns access_token, refresh_token, and user object.
  @POST('/auth/v1/token?grant_type=password')
  Future<AuthResponseModel> login(
    @Body() LoginRequestModel request,
  );

  /// Create a new user account.
  ///
  /// Supabase stores `data` field as `user_metadata`.
  @POST('/auth/v1/signup')
  Future<AuthResponseModel> register(
    @Body() RegisterRequestModel request,
  );

  /// Refresh an expired access token.
  @POST('/auth/v1/token?grant_type=refresh_token')
  Future<AuthResponseModel> refreshToken(
    @Body() Map<String, dynamic> body,
  );

  /// Get the currently authenticated user.
  ///
  /// Requires `Authorization: Bearer <access_token>` header.
  @GET('/auth/v1/user')
  Future<UserModel> getCurrentUser();

  /// Send a password recovery email to the specified address.
  @POST('/auth/v1/recover')
  Future<void> requestPasswordReset(
    @Body() Map<String, dynamic> body,
  );

  /// Sign out the current user.
  ///
  /// Requires `Authorization: Bearer <access_token>` header.
  @POST('/auth/v1/logout')
  Future<void> logout();
}
