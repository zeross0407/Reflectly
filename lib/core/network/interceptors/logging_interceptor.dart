import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// LoggingInterceptor - Để ghi log các request và response
/// Chỉ hoạt động trong Debug mode
class LoggingInterceptor extends Interceptor {
  final bool enableRequestBody;
  final bool enableRequestHeader;
  final bool enableResponseBody;
  final bool enableResponseHeader;
  final bool enableErrorBody;

  LoggingInterceptor({
    this.enableRequestBody = true, 
    this.enableRequestHeader = true,
    this.enableResponseBody = true,
    this.enableResponseHeader = false,
    this.enableErrorBody = true,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      _logRequest(options);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      _logResponse(response);
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      _logError(err);
    }
    super.onError(err, handler);
  }

  void _logRequest(RequestOptions options) {
    debugPrint('┌── Request ────────────────────────────────────────────');
    debugPrint('│ ${options.method} ${options.uri}');
    
    if (enableRequestHeader) {
      debugPrint('│ Headers:');
      options.headers.forEach((key, value) {
        if (key.toLowerCase() == 'authorization') {
          // Ẩn token nhạy cảm
          debugPrint('│   $key: Bearer ***');
        } else {
          debugPrint('│   $key: $value');
        }
      });
    }
    
    if (enableRequestBody && options.data != null) {
      debugPrint('│ Body: ${_sanitizeBody(options.data)}');
    }
    
    debugPrint('└─────────────────────────────────────────────────────────');
  }

  void _logResponse(Response response) {
    debugPrint('┌── Response ────────────────────────────────────────────');
    debugPrint('│ ${response.requestOptions.method} ${response.requestOptions.uri}');
    debugPrint('│ Status: ${response.statusCode}');
    debugPrint('│ Duration: ${response.requestOptions.extra['duration'] ?? 'N/A'}');
    
    if (enableResponseHeader) {
      debugPrint('│ Headers:');
      response.headers.forEach((name, values) {
        debugPrint('│   $name: ${values.join(', ')}');
      });
    }
    
    if (enableResponseBody) {
      debugPrint('│ Body: ${_sanitizeBody(response.data)}');
    }
    
    debugPrint('└─────────────────────────────────────────────────────────');
  }

  void _logError(DioException err) {
    debugPrint('┌── Error ────────────────────────────────────────────');
    debugPrint('│ ${err.requestOptions.method} ${err.requestOptions.uri}');
    debugPrint('│ ${err.type}');
    debugPrint('│ ${err.message}');
    
    if (err.response != null) {
      debugPrint('│ Status: ${err.response!.statusCode}');
      
      if (enableErrorBody) {
        debugPrint('│ Body: ${_sanitizeBody(err.response!.data)}');
      }
    }
    
    debugPrint('└─────────────────────────────────────────────────────────');
  }

  String _sanitizeBody(dynamic data) {
    String sanitized = data.toString();
    if (sanitized.length > 1000) {
      sanitized = '${sanitized.substring(0, 1000)}... (${sanitized.length - 1000} more bytes)';
    }
    return sanitized;
  }
} 