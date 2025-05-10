import 'package:dio/dio.dart';
import 'package:myrefectly/core/network/api_endpoints.dart';

/// AuthInterceptor - Interceptor xử lý authentication
/// - Thêm token vào request
/// - Xử lý refresh token khi token hết hạn
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final String Function() getAccessToken;
  final String Function() getRefreshToken;
  final Function(String accessToken, String refreshToken)? onTokensRefreshed;

  AuthInterceptor({
    required this.dio,
    required this.getAccessToken,
    required this.getRefreshToken,
    this.onTokensRefreshed,
  });

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final accessToken = getAccessToken();
    if (accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldRefreshToken(err)) {
      try {
        final refreshToken = getRefreshToken();
        final newTokens = await _refreshToken(refreshToken);
        
        if (newTokens != null && onTokensRefreshed != null) {
          onTokensRefreshed!(
            newTokens['accessToken'] as String,
            newTokens['refreshToken'] as String,
          );
          
          // Retry request với token mới
          final response = await _retryRequest(err.requestOptions, newTokens['accessToken'] as String);
          handler.resolve(response);
          return;
        }
      } catch (e) {
        // Xử lý khi refresh token thất bại
        handler.next(err);
        return;
      }
    }
    
    handler.next(err);
  }

  bool _shouldRefreshToken(DioException error) {
    return error.response?.statusCode == 401 && getRefreshToken().isNotEmpty;
  }

  Future<Map<String, dynamic>?> _refreshToken(String refreshToken) async {
    try {
      final response = await dio.post(
        ApiEndpoints.refreshToken,
        queryParameters: {'refreshToken': refreshToken},
      );
      
      if (response.statusCode == 200) {
        return {
          'accessToken': response.data['accessToken'],
          'refreshToken': response.data['refreshToken'] ?? refreshToken,
        };
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Response> _retryRequest(RequestOptions requestOptions, String accessToken) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $accessToken',
      },
    );
    
    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
} 