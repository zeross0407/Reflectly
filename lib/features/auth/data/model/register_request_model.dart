import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request_model.freezed.dart';
part 'register_request_model.g.dart';

/// Request body for Supabase GoTrue sign-up.
///
/// Endpoint: `POST /auth/v1/signup`
///
/// Supabase stores custom fields (like username) inside `data`
/// which maps to `user_metadata` in the user object.
@freezed
class RegisterRequestModel with _$RegisterRequestModel {
  const factory RegisterRequestModel({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) = _RegisterRequestModel;

  factory RegisterRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestModelFromJson(json);
}
