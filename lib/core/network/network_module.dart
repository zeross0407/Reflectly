/// Core network layer — barrel export.
///
/// Import this single file to access the entire network infrastructure:
/// ```dart
/// import 'package:myrefectly/core/network/network_module.dart';
/// ```

// ── Environment ───────────────────────────────────────────────
export '../env/env_config.dart';

// ── Client ────────────────────────────────────────────────────
export 'dio_client.dart';

// ── Models ────────────────────────────────────────────────────
export 'models/api_response.dart';
export 'models/failure.dart';

// ── Interceptors ──────────────────────────────────────────────
export 'interceptors/auth_interceptor.dart';
export 'interceptors/error_interceptor.dart';
export 'interceptors/logging_interceptor.dart';
export 'interceptors/retry_interceptor.dart';

// ── Token ─────────────────────────────────────────────────────
export 'token/token_manager.dart';

// ── Connectivity ──────────────────────────────────────────────
export 'connectivity/network_info.dart';
