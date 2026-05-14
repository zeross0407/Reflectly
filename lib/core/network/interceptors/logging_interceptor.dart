import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Pretty-prints HTTP request/response details for debugging.
///
/// Only active in debug mode (`kDebugMode`).
/// Masks sensitive headers like `Authorization`.
class LoggingInterceptor extends Interceptor {
  /// Maximum characters to log from response body.
  final int maxBodyLength;

  LoggingInterceptor({this.maxBodyLength = 1000});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      final buffer = StringBuffer()
        ..writeln('┌── REQUEST ──────────────────────────────────')
        ..writeln('│ ${options.method.toUpperCase()} ${options.uri}')
        ..writeln('│ Headers: ${_maskHeaders(options.headers)}');

      if (options.data != null) {
        buffer.writeln('│ Body: ${_truncate(options.data.toString())}');
      }

      if (options.queryParameters.isNotEmpty) {
        buffer.writeln('│ Query: ${options.queryParameters}');
      }

      buffer.writeln('└─────────────────────────────────────────────');
      developer.log(buffer.toString(), name: 'HTTP');
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    if (kDebugMode) {
      final duration = response.requestOptions.extra['_startTime'] != null
          ? DateTime.now()
              .difference(
                  response.requestOptions.extra['_startTime'] as DateTime)
              .inMilliseconds
          : null;

      final buffer = StringBuffer()
        ..writeln('┌── RESPONSE ─────────────────────────────────')
        ..writeln(
            '│ ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.uri}');

      if (duration != null) {
        buffer.writeln('│ Duration: ${duration}ms');
      }

      if (response.data != null) {
        buffer.writeln('│ Body: ${_truncate(response.data.toString())}');
      }

      buffer.writeln('└─────────────────────────────────────────────');
      developer.log(buffer.toString(), name: 'HTTP');
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      final buffer = StringBuffer()
        ..writeln('┌── ERROR ────────────────────────────────────')
        ..writeln(
            '│ ${err.response?.statusCode ?? 'N/A'} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.uri}')
        ..writeln('│ Type: ${err.type}')
        ..writeln('│ Message: ${err.message}');

      if (err.response?.data != null) {
        buffer
            .writeln('│ Response: ${_truncate(err.response!.data.toString())}');
      }

      buffer.writeln('└─────────────────────────────────────────────');
      developer.log(buffer.toString(), name: 'HTTP');
    }

    handler.next(err);
  }

  /// Replaces sensitive header values with `***`.
  Map<String, dynamic> _maskHeaders(Map<String, dynamic> headers) {
    const sensitiveKeys = {'authorization', 'cookie', 'set-cookie'};
    return headers.map((key, value) {
      if (sensitiveKeys.contains(key.toLowerCase())) {
        return MapEntry(key, '***');
      }
      return MapEntry(key, value);
    });
  }

  /// Truncates long strings to [maxBodyLength].
  String _truncate(String text) {
    if (text.length <= maxBodyLength) return text;
    return '${text.substring(0, maxBodyLength)}... [TRUNCATED]';
  }
}
