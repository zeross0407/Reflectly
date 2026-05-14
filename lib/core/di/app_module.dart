import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';

import 'package:myrefectly/core/env/env_config.dart';
import 'package:myrefectly/core/network/connectivity/network_info.dart';
import 'package:myrefectly/core/network/dio_client.dart';
import 'package:myrefectly/core/network/token/token_manager.dart';

/// Registers 3rd-party and generated classes that can't be
/// annotated directly with `@injectable`.
///
/// This replaces all manual `sl.registerLazySingleton(...)` calls.
@module
abstract class AppModule {
  // ── Network ─────────────────────────────────────────────────

  @lazySingleton
  Connectivity get connectivity => Connectivity();

  @lazySingleton
  TokenManager get tokenManager => TokenManager();

  @lazySingleton
  NetworkInfo get networkInfo => NetworkInfoImpl();

  @lazySingleton
  DioClient get dioClient => DioClient(
        config: DioConfig(
          baseUrl: EnvConfig.baseUrl,
          extraHeaders: {'apikey': EnvConfig.apiKey},
        ),
        tokenManager: tokenManager,
      );
}
