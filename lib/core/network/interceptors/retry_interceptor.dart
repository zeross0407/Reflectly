import 'dart:async';

import 'package:dio/dio.dart';

/// Automatically retries failed requests with exponential backoff.
///
/// Only retries on:
/// - Network errors (connection timeout, receive timeout, unknown)
/// - Server errors (5xx status codes)
///
/// Does NOT retry:
/// - Client errors (4xx) — these are intentional responses
/// - Cancellations — explicitly cancelled by the caller
class RetryInterceptor extends Interceptor {
  /// Maximum number of retries before giving up.
  final int maxRetries;

  /// Initial delay before the first retry (doubles each attempt).
  final Duration retryDelay;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    final retryCount = err.requestOptions.extra['_retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      handler.next(err);
      return;
    }

    // Exponential backoff: 1s → 2s → 4s → ...
    final delay = retryDelay * (1 << retryCount);
    await Future.delayed(delay);

    // Mark retry attempt
    err.requestOptions.extra['_retryCount'] = retryCount + 1;

    try {
      // Use a fresh Dio to avoid infinite interceptor loops
      final dio = Dio(BaseOptions(baseUrl: err.requestOptions.baseUrl));
      final response = await dio.request(
        err.requestOptions.path,
        options: Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          responseType: err.requestOptions.responseType,
          contentType: err.requestOptions.contentType,
        ),
        data: err.requestOptions.data,
        queryParameters: err.requestOptions.queryParameters,
      );

      handler.resolve(response);
    } on DioException catch (e) {
      // Recursively retry (count is tracked in extras)
      onError(e, handler);
    }
  }

  /// Determines if the error type is eligible for retry.
  bool _shouldRetry(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badResponse:
        // Only retry server errors (5xx)
        final statusCode = err.response?.statusCode ?? 0;
        return statusCode >= 500;
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
        return false;
    }
  }
}
