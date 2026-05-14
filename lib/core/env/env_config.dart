/// Environment configuration loaded from `--dart-define-from-file`.
///
/// Values are injected at **compile time** via:
/// ```bash
/// flutter run --flavor dev --dart-define-from-file=.env/.env.dev
/// flutter run --flavor production --dart-define-from-file=.env/.env.production
/// ```
///
/// All values use [String.fromEnvironment] / [bool.fromEnvironment],
/// which are **tree-shaken** by the Dart compiler — unused keys don't
/// leak into the release binary.
///
/// Usage anywhere in the app:
/// ```dart
/// import 'package:myrefectly/core/env/env_config.dart';
///
/// final url = EnvConfig.baseUrl;      // 'https://your-api.supabase.co'
/// final key = EnvConfig.apiKey;       // 'your_anon_key_here'
/// final isDev = EnvConfig.isDebug;    // true / false
/// ```
abstract class EnvConfig {
  const EnvConfig._();

  // ── Core ────────────────────────────────────────────────────

  /// Current environment name: `dev` or `production`.
  static const String env = String.fromEnvironment(
    'ENV',
    defaultValue: 'dev',
  );

  /// Display name of the app (matches flavor config).
  static const String appName = String.fromEnvironment(
    'APP_NAME',
    defaultValue: 'Reflectly',
  );

  // ── Network (Main Backend) ──────────────────────────────────

  /// Base URL for your main backend API.
  static const String baseUrl = String.fromEnvironment(
    'BASE_URL',
    defaultValue: 'http://localhost:8080',
  );

  /// API key / anon key for main backend authentication.
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  // ── Third-Party Services ────────────────────────────────────
  //
  // Mỗi dịch vụ ngoài có base URL riêng.
  // Thêm key vào .env files, khai báo const ở đây.
  //
  // Ví dụ tạo DioClient riêng cho từng service:
  //
  //   final storageDio = DioClient(
  //     config: DioConfig(baseUrl: EnvConfig.storageUrl),
  //     tokenManager: tokenManager,
  //   );
  //
  //   final aiDio = DioClient(
  //     config: DioConfig(baseUrl: EnvConfig.aiServiceUrl),
  //     tokenManager: tokenManager,
  //   );

  /// Base URL for file storage service (e.g. Cloudinary, S3).
  static const String storageUrl = String.fromEnvironment(
    'STORAGE_URL',
    defaultValue: '',
  );

  /// API key for storage service.
  static const String storageKey = String.fromEnvironment(
    'STORAGE_KEY',
    defaultValue: '',
  );

  /// Base URL for AI service (e.g. OpenAI, Gemini).
  static const String aiServiceUrl = String.fromEnvironment(
    'AI_SERVICE_URL',
    defaultValue: '',
  );

  /// API key for AI service.
  static const String aiServiceKey = String.fromEnvironment(
    'AI_SERVICE_KEY',
    defaultValue: '',
  );

  // ── Flags ───────────────────────────────────────────────────

  /// Whether the app is running in debug/dev mode.
  static const bool isDebug = bool.fromEnvironment(
    'DEBUG',
    defaultValue: true,
  );

  // ── Helpers ─────────────────────────────────────────────────

  /// Returns `true` if running in production.
  static bool get isProduction => env == 'production';

  /// Returns `true` if running in dev.
  static bool get isDev => env == 'dev';
}
