import 'package:dio/dio.dart';

import '../env/env_config.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'token/token_manager.dart';

/// Configuration for creating a [Dio] client.
///
/// [baseUrl] defaults to [EnvConfig.baseUrl] — the value injected
/// at compile time via `--dart-define-from-file`.
class DioConfig {
  /// Base URL for all requests.
  /// Defaults to [EnvConfig.baseUrl] from the active `.env` file.
  final String baseUrl;

  /// Connection timeout duration.
  final Duration connectTimeout;

  /// Response receive timeout duration.
  final Duration receiveTimeout;

  /// Request send timeout duration.
  final Duration sendTimeout;

  /// Extra default headers applied to every request.
  final Map<String, dynamic> extraHeaders;

  const DioConfig({
    this.baseUrl = EnvConfig.baseUrl,
    this.connectTimeout = const Duration(seconds: 15),
    this.receiveTimeout = const Duration(seconds: 15),
    this.sendTimeout = const Duration(seconds: 15),
    this.extraHeaders = const {},
  });
}

/// Factory that creates fully configured [Dio] instances.
///
/// Each Dio instance comes with the complete interceptor pipeline:
/// 1. [AuthInterceptor] — token injection + 401 refresh
/// 2. [RetryInterceptor] — auto-retry with exponential backoff
/// 3. [ErrorInterceptor] — DioException → Failure mapping
/// 4. [LoggingInterceptor] — pretty-print logs (debug only)
///
/// Usage:
/// ```dart
/// final dioClient = DioClient(
///   config: DioConfig(baseUrl: 'https://api.example.com'),
///   tokenManager: tokenManager,
/// );
///
/// // Use with Retrofit
/// final apiService = AuthApiService(dioClient.dio);
/// ```
class DioClient {
  final DioConfig config;
  final TokenManager tokenManager;
  final Future<void> Function()? onForceLogout;

  late final Dio _dio;

  DioClient({
    required this.config,
    required this.tokenManager,
    this.onForceLogout,
  }) {
    _dio = _createDio();
  }

  /// The configured [Dio] instance. Pass this to Retrofit services.
  Dio get dio => _dio;

  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: config.baseUrl,
        connectTimeout: config.connectTimeout,
        receiveTimeout: config.receiveTimeout,
        sendTimeout: config.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          ...config.extraHeaders,
        },
      ),
    );

    // Interceptor order matters:
    // 1. Auth first — injects tokens before anything else
    // 2. Retry — retries failed requests (with updated tokens)
    // 3. Error — maps any remaining errors to typed Failures
    // 4. Logging last — logs the final request/response state
    dio.interceptors.addAll([
      AuthInterceptor(
        tokenManager: tokenManager,
        onForceLogout: onForceLogout,
      ),
      RetryInterceptor(),
      ErrorInterceptor(),
      LoggingInterceptor(),
    ]);

    return dio;
  }
}
