import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:myrefectly/core/error/exceptions.dart';

/// Dio Client tuân thủ Clean Architecture
/// Tầng Infrastructure - Cung cấp implementation cụ thể cho Network Requests
class DioClient {
  final Dio _dio;

  /// Constructor với Dependency Injection
  DioClient(this._dio);

  /// GET Request
  Future<dynamic> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  /// POST Request
  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  /// PUT Request
  Future<dynamic> put(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  /// DELETE Request
  Future<dynamic> delete(
    String url, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response.data;
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      _handleError(e);
    }
  }

  /// Xử lý lỗi từ Dio và chuyển thành Exception của ứng dụng
  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException(
          message: 'Connection timeout',
          statusCode: 408,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final message = error.response?.statusMessage ?? 'Server error';

        if (statusCode == 401) {
          throw AuthException(
            message: 'Unauthorized',
            code: statusCode,
          );
        }

        throw ServerException(
          message: message,
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        throw ServerException(
          message: 'Request cancelled',
          statusCode: 499,
        );
      case DioExceptionType.unknown:
        if (error.error is Exception) {
          throw ServerException(
            message: 'No internet connection',
            statusCode: 503,
          );
        }
        throw ServerException(
          message: error.message ?? 'Unknown error',
          statusCode: 500,
        );
      default:
        throw ServerException(
          message: error.message ?? 'Unknown error',
          statusCode: 500,
        );
    }
  }

  /// Xử lý lỗi không phải từ Dio
  dynamic _handleError(dynamic error) {
    debugPrint('Non-Dio Error: $error');
    throw ServerException(
      message: 'Unknown error occurred',
      statusCode: 500,
    );
  }
}
