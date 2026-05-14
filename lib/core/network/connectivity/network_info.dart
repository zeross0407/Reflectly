import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstraction for checking network connectivity.
///
/// Used by repositories to decide between local cache and remote calls.
///
/// ```dart
/// if (!await networkInfo.isConnected) {
///   return Left(Failure.network(message: 'No internet connection'));
/// }
/// ```
abstract class NetworkInfo {
  /// Returns `true` if the device has an active internet connection.
  Future<bool> get isConnected;

  /// Emits `true` when connected, `false` when disconnected.
  Stream<bool> get onConnectivityChanged;
}

/// Implementation using `connectivity_plus` package.
///
/// Replaces the old `lib/network/network_service.dart`.
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;

  NetworkInfoImpl({Connectivity? connectivity})
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  /// Checks if any result indicates an active connection.
  bool _hasConnection(List<ConnectivityResult> results) {
    return results.any((r) =>
        r == ConnectivityResult.mobile ||
        r == ConnectivityResult.wifi ||
        r == ConnectivityResult.ethernet);
  }
}
