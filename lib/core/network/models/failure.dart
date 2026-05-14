import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

/// Typed failure union using Freezed.
///
/// Use pattern matching to handle each case in BLoC/UI:
/// ```dart
/// failure.when(
///   server: (message, statusCode) => ...,
///   network: (message) => ...,
///   unauthorized: (message) => ...,
///   ...
/// );
/// ```
@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.network({
    required String message,
  }) = NetworkFailure;

  const factory Failure.unauthorized({
    required String message,
  }) = UnauthorizedFailure;

  const factory Failure.notFound({
    required String message,
  }) = NotFoundFailure;

  const factory Failure.timeout({
    required String message,
  }) = TimeoutFailure;

  const factory Failure.unknown({
    required String message,
  }) = UnknownFailure;

  const factory Failure.cache({
    required String message,
  }) = CacheFailure;
}
