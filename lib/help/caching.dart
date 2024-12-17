import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

class MemCacheStoreWithTracking extends CacheStore {
  final Map<String, CacheResponse> _cache = {};
  final Set<String> _cachedKeys = {};

  @override
  Future<void> delete(String key, {bool staleOnly = false}) async {
    _cache.remove(key);
    _cachedKeys.remove(key);
  }

  @override
  Future<void> deleteFromPath(RegExp pathPattern,
      {Map<String, String?>? queryParams}) async {
    _cachedKeys.removeWhere((key) => pathPattern.hasMatch(key));
    _cache.removeWhere((key, value) => pathPattern.hasMatch(key));
  }

  @override
  Future<void> clean(
      {CachePriority priorityOrBelow = CachePriority.high,
      bool staleOnly = false}) async {
    _cache.clear();
    _cachedKeys.clear();
  }

  @override
  Future<void> close() async {
    _cache.clear();
    _cachedKeys.clear();
  }

  @override
  Future<bool> exists(String key) async {
    return _cache.containsKey(key);
  }

  @override
  Future<List<CacheResponse>> getFromPath(RegExp pathPattern,
      {Map<String, String?>? queryParams}) async {
    List<CacheResponse> results = [];
    for (var key in _cachedKeys) {
      if (pathPattern.hasMatch(key)) {
        results.add(_cache[key]!);
      }
    }
    return results;
  }

  @override
  Future<CacheResponse?> get(String key) async {
    return _cache[key];
  }

  @override
  Future<void> set(CacheResponse response) async {
    _cache[response.key] = response;
    _cachedKeys.add(response.key);
    caching_key[response.url] = response.key;
    print('Cache set for key: ${response.key}');
  }

  Set<String> getCachedKeys() {
    return _cachedKeys;
  }
}

Map<String, String> caching_key = {};
