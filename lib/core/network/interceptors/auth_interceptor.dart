import 'package:dio/dio.dart';

import '../token/token_manager.dart';

/// Interceptor that injects auth tokens into outgoing requests
/// and handles 401 responses with token refresh.
///
/// Replaces the old `DIOInterceptor.dart` with a cleaner implementation.
class AuthInterceptor extends Interceptor {
  final TokenManager _tokenManager;

  /// Callback invoked when a forced logout is needed
  /// (e.g. refresh token is also expired).
  final Future<void> Function()? onForceLogout;

  /// Endpoints that should NOT receive auth headers.
  final Set<String> _publicEndpoints = {
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  };

  AuthInterceptor({
    required TokenManager tokenManager,
    this.onForceLogout,
  }) : _tokenManager = tokenManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip token injection for public endpoints
    final path = options.path;
    final isPublic = _publicEndpoints.any(
      (endpoint) => path.contains(endpoint),
    );

    if (!isPublic) {
      final token = await _tokenManager.accessToken;
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Attempt token refresh
      final refreshed = await _attemptTokenRefresh(err);
      if (refreshed != null) {
        // Retry original request with new token
        handler.resolve(refreshed);
        return;
      }

      // Refresh failed → force logout
      await onForceLogout?.call();
    }

    handler.next(err);
  }

  /// Attempts to refresh the access token and retry the failed request.
  ///
  /// Returns the successful retry [Response], or `null` if refresh failed.
  Future<Response<dynamic>?> _attemptTokenRefresh(DioException err) async {
    try {
      final refreshToken = await _tokenManager.refreshToken;
      if (refreshToken == null || refreshToken.isEmpty) return null;

      // Use a clean Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(
        baseUrl: err.requestOptions.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));

      final response = await refreshDio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access_token'] as String?;
        final newRefreshToken = response.data['refresh_token'] as String?;

        if (newAccessToken != null) {
          if (newRefreshToken != null) {
            await _tokenManager.saveTokens(
              accessToken: newAccessToken,
              refreshToken: newRefreshToken,
            );
          } else {
            await _tokenManager.updateAccessToken(newAccessToken);
          }

          // Retry original request with new token
          final opts = err.requestOptions;
          opts.headers['Authorization'] = 'Bearer $newAccessToken';

          final retryDio = Dio(BaseOptions(baseUrl: opts.baseUrl));
          return await retryDio.request(
            opts.path,
            options: Options(
              method: opts.method,
              headers: opts.headers,
            ),
            data: opts.data,
            queryParameters: opts.queryParameters,
          );
        }
      }
    } catch (_) {
      // Refresh failed — will trigger force logout in caller
    }

    return null;
  }
}
