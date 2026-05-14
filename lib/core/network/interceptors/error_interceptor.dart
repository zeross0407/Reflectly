import 'package:dio/dio.dart';

import '../models/failure.dart';

/// Maps [DioException] instances to typed [Failure] objects.
///
/// Placed at the end of the interceptor pipeline so it catches
/// any errors not already handled by Auth/Retry interceptors.
///
/// Usage in repository:
/// ```dart
/// try {
///   final response = await _apiService.getUser(id);
///   return Right(response);
/// } on DioException catch (e) {
///   return Left(e.toFailure());
/// }
/// ```
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Attach the mapped Failure to the error's extras for easy access
    err.requestOptions.extra['_failure'] = _mapToFailure(err);
    handler.next(err);
  }

  Failure _mapToFailure(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Failure.timeout(
          message: 'Connection timed out. Please try again.',
        );

      case DioExceptionType.connectionError:
        return Failure.network(
          message: 'No internet connection. Please check your network.',
        );

      case DioExceptionType.badResponse:
        return _mapStatusCode(err);

      case DioExceptionType.cancel:
        return const Failure.unknown(message: 'Request was cancelled.');

      case DioExceptionType.badCertificate:
        return const Failure.unknown(
          message: 'Invalid certificate. Connection is not secure.',
        );

      case DioExceptionType.unknown:
      default:
        return Failure.unknown(
          message: err.message ?? 'An unexpected error occurred.',
        );
    }
  }

  Failure _mapStatusCode(DioException err) {
    final statusCode = err.response?.statusCode;
    final responseData = err.response?.data;

    // Try to extract error message from response body
    String message = 'Something went wrong.';
    if (responseData is Map<String, dynamic>) {
      message = responseData['message'] as String? ??
          responseData['error'] as String? ??
          message;
    }

    switch (statusCode) {
      case 400:
        return Failure.server(message: message, statusCode: 400);
      case 401:
        return Failure.unauthorized(message: message);
      case 403:
        return Failure.unauthorized(
          message: 'Access denied. You don\'t have permission.',
        );
      case 404:
        return Failure.notFound(message: message);
      case 409:
        return Failure.server(message: message, statusCode: 409);
      case 422:
        return Failure.server(message: message, statusCode: 422);
      case 429:
        return Failure.server(
          message: 'Too many requests. Please slow down.',
          statusCode: 429,
        );
      default:
        if (statusCode != null && statusCode >= 500) {
          return Failure.server(
            message: 'Server error. Please try again later.',
            statusCode: statusCode,
          );
        }
        return Failure.unknown(message: message);
    }
  }
}

/// Extension to conveniently extract [Failure] from [DioException].
extension DioExceptionX on DioException {
  /// Returns the [Failure] mapped by [ErrorInterceptor],
  /// or creates one on the fly if the interceptor wasn't in the pipeline.
  Failure toFailure() {
    final stored = requestOptions.extra['_failure'];
    if (stored is Failure) return stored;

    // Fallback mapping if ErrorInterceptor wasn't used
    return Failure.unknown(
      message: message ?? 'An unexpected error occurred.',
    );
  }
}
