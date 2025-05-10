import 'package:connectivity_plus/connectivity_plus.dart';

/// Interface cho Network Info
/// Theo Clean Architecture, đây là interface ở tầng Domain
abstract class NetworkInfo {
  Future<bool> get isConnected;
}

/// Implementation của NetworkInfo
/// Đây là implementation ở tầng Infrastructure
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity connectivity;

  NetworkInfoImpl(this.connectivity);

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
} 