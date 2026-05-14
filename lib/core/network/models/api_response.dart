import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response.freezed.dart';
part 'api_response.g.dart';

/// Generic API response wrapper using Freezed.
///
/// Wraps backend responses in a consistent format:
/// ```json
/// {
///   "data": { ... },
///   "message": "Success",
///   "success": true
/// }
/// ```
///
/// Usage with Retrofit:
/// ```dart
/// @GET('/users/{id}')
/// Future<ApiResponse<UserModel>> getUser(@Path('id') String id);
/// ```
@Freezed(genericArgumentFactories: true)
class ApiResponse<T> with _$ApiResponse<T> {
  const factory ApiResponse({
    required T data,
    String? message,
    @Default(true) bool success,
  }) = _ApiResponse;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object?) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);
}
