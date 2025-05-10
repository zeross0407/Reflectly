import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

/// CacheInterceptor - Wrapper cho Dio Caching
/// Giúp tích hợp CacheOptions với Clean Architecture
class CacheInterceptor extends Interceptor {
  final CacheStore cacheStore;
  final CachePolicy defaultPolicy;
  final Duration maxStale;
  final int maxEntrySize;
  final bool hitCacheOnErrorExcept;
  final List<int> excludeStatusCodes;

  CacheInterceptor({
    required this.cacheStore,
    this.defaultPolicy = CachePolicy.request,
    this.maxStale = const Duration(days: 7),
    this.maxEntrySize = 10485760, // 10 MB
    this.hitCacheOnErrorExcept = true,
    this.excludeStatusCodes = const [401, 403],
  }) {
    // Cleanup expired cache entries
    _cleanupExpiredCache();
  }
  
  /// Lấy CacheOptions từ interceptor này
  CacheOptions get cacheOptions => CacheOptions(
    store: cacheStore,
    policy: defaultPolicy,
    maxStale: maxStale,
    priority: CachePriority.normal,
    hitCacheOnErrorExcept: excludeStatusCodes,
    keyBuilder: CacheOptions.defaultCacheKeyBuilder,
    allowPostMethod: false,
  );

  /// Tạo Dio Interceptor từ CacheOptions
  DioCacheInterceptor get asDioInterceptor => DioCacheInterceptor(
    options: cacheOptions,
  );

  /// Xóa cache
  Future<void> deleteCache({RegExp? requestPattern}) async {
    if (requestPattern != null) {
      await cacheStore.deleteFromPath(requestPattern);
    } else {
      await cacheStore.clean();
    }
  }

  /// Xóa cache theo URL cụ thể
  Future<void> invalidateCache(String url) async {
    final pattern = RegExp(url, caseSensitive: false);
    await cacheStore.deleteFromPath(pattern);
  }

  /// Xóa các entry cache đã hết hạn
  Future<void> _cleanupExpiredCache() async {
    await cacheStore.clean(staleOnly: true);
  }
} 