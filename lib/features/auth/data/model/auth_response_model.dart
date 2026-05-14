import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:myrefectly/features/auth/domain/entity/auth_entity.dart';

part 'auth_response_model.freezed.dart';
part 'auth_response_model.g.dart';

/// Response from Supabase GoTrue sign-in / sign-up.
///
/// Maps the Supabase JSON response to a typed Dart object,
/// then converts to domain entity via [toEntity].
@freezed
class AuthResponseModel with _$AuthResponseModel {
  const AuthResponseModel._();

  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AuthResponseModel({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'refresh_token') required String refreshToken,
    @JsonKey(name: 'expires_in') @Default(3600) int expiresIn,
    @JsonKey(name: 'token_type') @Default('bearer') String tokenType,
    required UserModel user,
  }) = _AuthResponseModel;

  factory AuthResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseModelFromJson(json);

  /// Maps this data model to a pure domain entity.
  AuthSession toEntity() => AuthSession(
        accessToken: accessToken,
        refreshToken: refreshToken,
        expiresIn: expiresIn,
        user: user.toEntity(),
      );
}

/// Supabase user object from GoTrue response.
@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    String? email,
    @JsonKey(name: 'user_metadata') Map<String, dynamic>? userMetadata,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Maps to domain entity, extracting username from user_metadata.
  AuthUser toEntity() => AuthUser(
        id: id,
        email: email ?? '',
        username: userMetadata?['username'] as String?,
        avatarUrl: userMetadata?['avatar_url'] as String?,
      );
}
