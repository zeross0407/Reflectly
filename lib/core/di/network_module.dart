import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:get_it/get_it.dart';
import 'package:myrefectly/core/network/dio_client.dart';
import 'package:myrefectly/core/network/interceptors/auth_interceptor.dart';
import 'package:myrefectly/core/network/interceptors/cache_interceptor.dart';
import 'package:myrefectly/core/network/interceptors/logging_interceptor.dart';
import 'package:myrefectly/core/network/network_info.dart';
import 'package:myrefectly/help/caching.dart';

/// NetworkModule - Cung cấp dependency injection cho Network
/// Tuân thủ Clean Architecture bằng cách tạo các abstraction và implementation riêng biệt
class NetworkModule {
  final GetIt sl;
  final String baseUrl;
  
  NetworkModule(this.sl, {required this.baseUrl});
  
  void init() {
    // Network Info
    sl.registerLazySingleton<Connectivity>(() => Connectivity());
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
    
    // Cache Store
    sl.registerLazySingleton<CacheStore>(() => MemCacheStoreWithTracking());
    
    // Dio và các interceptor
    sl.registerLazySingleton(() => _createDio());
    sl.registerLazySingleton(() => DioClient(sl()));
  }
  
  Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
    
    // Logging Interceptor (chỉ dùng trong debug)
    dio.interceptors.add(LoggingInterceptor());
    
    // Cache Interceptor
    final cacheInterceptor = CacheInterceptor(
      cacheStore: sl<CacheStore>(),
      defaultPolicy: CachePolicy.refreshForceCache,
      maxStale: const Duration(days: 7),
    );
    dio.interceptors.add(cacheInterceptor.asDioInterceptor);
    
    // Auth Interceptor
    dio.interceptors.add(
      AuthInterceptor(
        dio: dio,
        getAccessToken: () => sl<String>(instanceName: 'access_token'),
        getRefreshToken: () => sl<String>(instanceName: 'refresh_token'),
        onTokensRefreshed: (accessToken, refreshToken) {
          // Trước khi đăng ký lại, cần unregister các instance cũ
          if (sl.isRegistered<String>(instanceName: 'access_token')) {
            sl.unregister<String>(instanceName: 'access_token');
          }
          if (sl.isRegistered<String>(instanceName: 'refresh_token')) {
            sl.unregister<String>(instanceName: 'refresh_token');
          }
          
          // Đăng ký token mới
          sl.registerSingleton<String>(
            accessToken,
            instanceName: 'access_token',
          );
          sl.registerSingleton<String>(
            refreshToken,
            instanceName: 'refresh_token',
          );
        },
      ),
    );
    
    return dio;
  }
} 