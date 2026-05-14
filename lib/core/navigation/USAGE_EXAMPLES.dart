// ignore_for_file: unused_local_variable
/// ─────────────────────────────────────────────────────────────
/// USAGE EXAMPLES — Navigation + DI System
/// ─────────────────────────────────────────────────────────────
///
/// Mục lục:
///   1. Setup trong main()
///   2. Điều hướng cơ bản
///   3. Điều hướng không context (BLoC, services)
///   4. Custom transitions
///   5. Thêm feature mới (routes + DI) — 4 bước
///   6. Deep link / Push notification
/// ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:myrefectly/core/navigation/navigation.dart';

// ═══════════════════════════════════════════════════════════════
// 1. SETUP TRONG MAIN()
// ═══════════════════════════════════════════════════════════════

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // 1. Register all dependencies
//   initDependencies();
//
//   // 2. Run app with navigation
//   runApp(MaterialApp(
//     navigatorKey: AppNavigator.navigatorKey,
//     onGenerateRoute: AppRouter.onGenerateRoute,
//     initialRoute: AppRoutes.splash,
//   ));
// }

// ═══════════════════════════════════════════════════════════════
// 2. ĐIỀU HƯỚNG CƠ BẢN
// ═══════════════════════════════════════════════════════════════

void example_basic(BuildContext context) {
  // Push
  Navigator.pushNamed(context, AppRoutes.login);

  // Push with arguments
  Navigator.pushNamed(context, AppRoutes.register, arguments: 'John');

  // Push and clear stack (after login success)
  Navigator.pushNamedAndRemoveUntil(context, AppRoutes.home, (r) => false);

  // Pop
  Navigator.pop(context);
}

// ═══════════════════════════════════════════════════════════════
// 3. ĐIỀU HƯỚNG KHÔNG CONTEXT (BLoC, services)
// ═══════════════════════════════════════════════════════════════

void example_global() {
  AppNavigator.pushNamed(AppRoutes.login);
  AppNavigator.pushNamedAndRemoveAll(AppRoutes.home);
  AppNavigator.pop();
  AppNavigator.popToRoot();
}

// ═══════════════════════════════════════════════════════════════
// 4. CUSTOM TRANSITIONS
// ═══════════════════════════════════════════════════════════════

// Available: slideUp, fade, slideLeft, slideRight, scale, none
//
// Trong RouteModule:
//   AppRoutes.detail: RouteConfig(
//     builder: (s) => DetailPage(),
//     transition: TransitionType.slideLeft,
//     duration: Duration(milliseconds: 400),
//   ),
//
// Trực tiếp:
//   Navigator.push(context, AppTransitions.scale(page: DetailPage()));

// ═══════════════════════════════════════════════════════════════
// 5. THÊM FEATURE MỚI — 4 bước
// ═══════════════════════════════════════════════════════════════

// ── Bước 1: Tạo DI module ──────────────────────────────────
// File: lib/features/entries/di/entries_di.dart
//
// void registerEntriesDependencies() {
//   sl.registerLazySingleton<EntriesRepository>(
//     () => EntriesRepositoryImpl(sl<DioClient>()),
//   );
//   sl.registerLazySingleton(() => GetEntriesUseCase(sl()));
//   sl.registerFactory(() => EntriesBloc(sl()));
// }

// ── Bước 2: Tạo Route module ───────────────────────────────
// File: lib/features/entries/routes/entries_route_module.dart
//
// class EntriesRouteModule extends RouteModule {
//   @override
//   Map<String, RouteConfig> get routes => {
//     AppRoutes.entries: RouteConfig(
//       builder: (s) => BlocProvider(
//         create: (_) => sl<EntriesBloc>(),
//         child: const EntriesPage(),
//       ),
//     ),
//     AppRoutes.entryDetail: RouteConfig(
//       builder: (s) {
//         final id = s.arguments as String;
//         return EntryDetailPage(entryId: id);
//       },
//       transition: TransitionType.slideLeft,
//     ),
//   };
// }

// ── Bước 3: Register DI ─────────────────────────────────────
// File: lib/core/di/init_dependencies.dart
//
// void initDependencies() {
//   registerAuthDependencies();
//   registerEntriesDependencies();   // ← thêm dòng này
// }

// ── Bước 4: Register Route Module ───────────────────────────
// File: lib/core/navigation/app_router.dart
//
// static final List<RouteModule> _modules = [
//   AuthRouteModule(),
//   EntriesRouteModule(),    // ← thêm dòng này
// ];

// ═══════════════════════════════════════════════════════════════
// 6. DEEP LINK / PUSH NOTIFICATION
// ═══════════════════════════════════════════════════════════════

// void handleDeepLink(String url) {
//   final uri = Uri.parse(url);
//   final (routeName, args) = AppRouter.parseDeepLink(uri);
//   AppNavigator.pushNamed(routeName, arguments: args);
// }
