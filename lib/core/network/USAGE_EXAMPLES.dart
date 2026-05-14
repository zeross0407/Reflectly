// ignore_for_file: unused_local_variable
/// ─────────────────────────────────────────────────────────────
/// USAGE EXAMPLES — Network Layer + EnvConfig + Retrofit
/// ─────────────────────────────────────────────────────────────
///
/// File này không phải code production — chỉ là tài liệu tham khảo.
/// Copy-paste các pattern bên dưới khi cần dùng.
///
/// Mục lục:
///   1. Setup DioClient cơ bản
///   2. Tạo Retrofit API Service
///   3. Dùng trong Repository (Clean Architecture)
///   4. Tích hợp dịch vụ ngoài (base URL khác)
///   5. Đọc env config
///   6. Chạy app với flavor + env
/// ─────────────────────────────────────────────────────────────

import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:retrofit/retrofit.dart';

import 'package:myrefectly/core/env/env_config.dart';
import 'package:myrefectly/core/network/dio_client.dart';
import 'package:myrefectly/core/network/models/failure.dart';
import 'package:myrefectly/core/network/models/api_response.dart';
import 'package:myrefectly/core/network/interceptors/error_interceptor.dart';
import 'package:myrefectly/core/network/token/token_manager.dart';
import 'package:myrefectly/core/network/connectivity/network_info.dart';

// ═══════════════════════════════════════════════════════════════
// 1. SETUP DIO CLIENT CƠ BẢN
// ═══════════════════════════════════════════════════════════════

/// DioClient mặc định — dùng cho main backend.
/// baseUrl tự động lấy từ EnvConfig (file .env).
void example_basic_setup() {
  final tokenManager = TokenManager();

  // Cách 1: Dùng mặc định (baseUrl = EnvConfig.baseUrl)
  final client = DioClient(
    config: const DioConfig(),
    tokenManager: tokenManager,
  );

  // Cách 2: Override baseUrl nếu cần
  final customClient = DioClient(
    config: const DioConfig(
      baseUrl: 'https://another-api.com',
      connectTimeout: Duration(seconds: 30),
    ),
    tokenManager: tokenManager,
  );

  // Cách 3: Thêm custom headers (ví dụ: API key header)
  final clientWithHeaders = DioClient(
    config: DioConfig(
      extraHeaders: {
        'apikey': EnvConfig.apiKey,
        'X-Custom-Header': 'my-value',
      },
    ),
    tokenManager: tokenManager,
  );

  // Lấy Dio instance để truyền vào Retrofit
  final Dio dio = client.dio;
}

// ═══════════════════════════════════════════════════════════════
// 2. TẠO RETROFIT API SERVICE
// ═══════════════════════════════════════════════════════════════

/// Bước 1: Định nghĩa API service interface với Retrofit annotations.
/// Bước 2: Chạy `dart run build_runner build` để generate code.
/// Bước 3: File `.g.dart` sẽ được tạo tự động.

// ── Auth API ──────────────────────────────────────────────────

// @RestApi()
// abstract class AuthApiService {
//   factory AuthApiService(Dio dio, {String? baseUrl}) = _AuthApiService;
//
//   @POST('/auth/login')
//   Future<ApiResponse<TokenResponse>> login(
//     @Body() LoginRequest request,
//   );
//
//   @POST('/auth/register')
//   Future<ApiResponse<TokenResponse>> register(
//     @Body() RegisterRequest request,
//   );
//
//   @POST('/auth/refresh')
//   Future<ApiResponse<TokenResponse>> refreshToken(
//     @Body() RefreshTokenRequest request,
//   );
//
//   @GET('/auth/me')
//   Future<ApiResponse<UserModel>> getProfile();
// }

// ── Entries API ───────────────────────────────────────────────

// @RestApi()
// abstract class EntryApiService {
//   factory EntryApiService(Dio dio, {String? baseUrl}) = _EntryApiService;
//
//   @GET('/entries')
//   Future<ApiResponse<List<EntryModel>>> getEntries(
//     @Query('page') int page,
//     @Query('limit') int limit,
//   );
//
//   @GET('/entries/{id}')
//   Future<ApiResponse<EntryModel>> getEntry(
//     @Path('id') String id,
//   );
//
//   @POST('/entries')
//   Future<ApiResponse<EntryModel>> createEntry(
//     @Body() CreateEntryRequest request,
//   );
//
//   @PUT('/entries/{id}')
//   Future<ApiResponse<EntryModel>> updateEntry(
//     @Path('id') String id,
//     @Body() UpdateEntryRequest request,
//   );
//
//   @DELETE('/entries/{id}')
//   Future<void> deleteEntry(
//     @Path('id') String id,
//   );
// }

// ── Upload API (multipart) ────────────────────────────────────

// @RestApi()
// abstract class UploadApiService {
//   factory UploadApiService(Dio dio, {String? baseUrl}) = _UploadApiService;
//
//   @POST('/upload/image')
//   @MultiPart()
//   Future<ApiResponse<UploadResponse>> uploadImage(
//     @Part(name: 'file') File file,
//   );
// }

// ═══════════════════════════════════════════════════════════════
// 3. DÙNG TRONG REPOSITORY (Clean Architecture)
// ═══════════════════════════════════════════════════════════════

/// Pattern chuẩn: Repository trả về Either<Failure, T>.
/// Left = lỗi (typed), Right = data thành công.

// ── Abstract (domain layer) ───────────────────────────────────

// abstract class AuthRepository {
//   Future<Either<Failure, TokenResponse>> login(LoginRequest request);
//   Future<Either<Failure, UserModel>> getProfile();
// }

// ── Implementation (data layer) ───────────────────────────────

// class AuthRepositoryImpl implements AuthRepository {
//   final AuthApiService _api;
//   final NetworkInfo _networkInfo;
//   final TokenManager _tokenManager;
//
//   AuthRepositoryImpl({
//     required AuthApiService api,
//     required NetworkInfo networkInfo,
//     required TokenManager tokenManager,
//   })  : _api = api,
//         _networkInfo = networkInfo,
//         _tokenManager = tokenManager;
//
//   @override
//   Future<Either<Failure, TokenResponse>> login(LoginRequest request) async {
//     // ① Kiểm tra mạng
//     if (!await _networkInfo.isConnected) {
//       return const Left(
//         Failure.network(message: 'Không có kết nối mạng'),
//       );
//     }
//
//     // ② Gọi API
//     try {
//       final response = await _api.login(request);
//
//       // ③ Lưu token
//       await _tokenManager.saveTokens(
//         accessToken: response.data.accessToken,
//         refreshToken: response.data.refreshToken,
//       );
//
//       return Right(response.data);
//     } on DioException catch (e) {
//       // ④ Map lỗi sang Failure (tự động bởi ErrorInterceptor)
//       return Left(e.toFailure());
//     }
//   }
//
//   @override
//   Future<Either<Failure, UserModel>> getProfile() async {
//     if (!await _networkInfo.isConnected) {
//       return const Left(
//         Failure.network(message: 'Không có kết nối mạng'),
//       );
//     }
//
//     try {
//       final response = await _api.getProfile();
//       return Right(response.data);
//     } on DioException catch (e) {
//       return Left(e.toFailure());
//     }
//   }
// }

// ── Dùng trong BLoC ──────────────────────────────────────────

// class AuthBloc extends Bloc<AuthEvent, AuthState> {
//   final AuthRepository _repository;
//
//   AuthBloc(this._repository) : super(AuthInitial()) {
//     on<LoginRequested>((event, emit) async {
//       emit(AuthLoading());
//
//       final result = await _repository.login(event.request);
//
//       result.fold(
//         // ← Left: Failure — xử lý lỗi theo type
//         (failure) => failure.when(
//           server: (message, statusCode) => emit(AuthError(message)),
//           network: (message) => emit(AuthError('Mất kết nối mạng')),
//           unauthorized: (message) => emit(AuthError('Sai tài khoản hoặc mật khẩu')),
//           notFound: (message) => emit(AuthError(message)),
//           timeout: (message) => emit(AuthError('Hết thời gian chờ')),
//           unknown: (message) => emit(AuthError(message)),
//           cache: (message) => emit(AuthError(message)),
//         ),
//         // → Right: Data — login thành công
//         (tokenResponse) => emit(AuthAuthenticated(tokenResponse)),
//       );
//     });
//   }
// }

// ═══════════════════════════════════════════════════════════════
// 4. TÍCH HỢP DỊCH VỤ NGOÀI (BASE URL KHÁC)
// ═══════════════════════════════════════════════════════════════

/// Mỗi dịch vụ ngoài = 1 DioClient riêng + 1 Retrofit service riêng.
/// URL & key đều nằm trong .env file → EnvConfig.

void example_third_party_services() {
  final tokenManager = TokenManager();

  // ── Main Backend ────────────────────────────────────────────
  final mainClient = DioClient(
    config: const DioConfig(), // baseUrl = EnvConfig.baseUrl (tự động)
    tokenManager: tokenManager,
  );
  // final authApi = AuthApiService(mainClient.dio);
  // final entryApi = EntryApiService(mainClient.dio);

  // ── Cloudinary (Upload ảnh) ─────────────────────────────────
  final storageClient = DioClient(
    config: DioConfig(
      baseUrl: EnvConfig.storageUrl,
      extraHeaders: {
        'Authorization': 'Bearer ${EnvConfig.storageKey}',
      },
      receiveTimeout: const Duration(seconds: 60), // upload cần timeout dài
      sendTimeout: const Duration(seconds: 60),
    ),
    tokenManager: tokenManager,
  );
  // final uploadApi = UploadApiService(storageClient.dio);

  // ── OpenAI / Gemini ─────────────────────────────────────────
  final aiClient = DioClient(
    config: DioConfig(
      baseUrl: EnvConfig.aiServiceUrl,
      extraHeaders: {
        'Authorization': 'Bearer ${EnvConfig.aiServiceKey}',
      },
    ),
    tokenManager: tokenManager,
  );
  // final aiApi = AiApiService(aiClient.dio);

  // ── Service bất kỳ — chỉ cần 3 bước: ───────────────────────
  // 1. Thêm URL + KEY vào .env files
  // 2. Thêm const vào EnvConfig
  // 3. Tạo DioClient + Retrofit service
}

// ═══════════════════════════════════════════════════════════════
// 5. ĐỌC ENV CONFIG
// ═══════════════════════════════════════════════════════════════

void example_read_env() {
  // Tất cả giá trị là compile-time const
  print('Environment: ${EnvConfig.env}');          // 'dev' hoặc 'production'
  print('App Name: ${EnvConfig.appName}');          // 'Reflectly Dev'
  print('Base URL: ${EnvConfig.baseUrl}');           // từ .env file
  print('API Key: ${EnvConfig.apiKey}');             // từ .env file
  print('Debug: ${EnvConfig.isDebug}');              // true hoặc false
  print('Is Production: ${EnvConfig.isProduction}'); // helper getter
  print('Is Dev: ${EnvConfig.isDev}');               // helper getter

  // Dùng trong logic
  if (EnvConfig.isProduction) {
    // Tắt crash reporting ở dev, bật ở prod
    // CrashReporting.enable();
  }

  if (EnvConfig.isDebug) {
    // Hiện debug overlay
    // DebugOverlay.show();
  }
}

// ═══════════════════════════════════════════════════════════════
// 6. CHẠY APP VỚI FLAVOR + ENV
// ═══════════════════════════════════════════════════════════════
//
// ── Terminal ──────────────────────────────────────────────────
//
//   # Dev (debug)
//   flutter run --flavor dev --dart-define-from-file=.env/.env.dev
//
//   # Production (release)
//   flutter run --flavor production --dart-define-from-file=.env/.env.production
//
//   # Build APK
//   flutter build apk --flavor production --dart-define-from-file=.env/.env.production
//
//   # Build IPA
//   flutter build ipa --flavor production --dart-define-from-file=.env/.env.production
//
// ── VS Code ───────────────────────────────────────────────────
//
//   Mở Run & Debug → chọn "Dev (debug)" hoặc "Production (release)"
//   → F5
//
//   Đã config sẵn trong .vscode/launch.json
//
// ═══════════════════════════════════════════════════════════════
