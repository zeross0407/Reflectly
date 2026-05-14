import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:myrefectly/help/caching.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/models/entry.dart';
import 'package:myrefectly/notification/vip.dart';
import 'package:myrefectly/views/entries/entries_viewmodel.dart';
import 'package:myrefectly/views/start/init.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'firebase_options.dart';
import 'package:local_auth/local_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myrefectly/help/color.dart';
import 'package:timezone/data/latest.dart' as tz;

// ── New Navigation System ──────────────────────────────────
import 'package:myrefectly/core/navigation/navigation.dart';

// ── Dependency Injection ───────────────────────────────────
import 'package:myrefectly/core/di/injection.dart';

final LocalAuthentication auth = LocalAuthentication();
var uuid = Uuid();
bool force_reset = false;
String refresh_token = "";
String access_token = "";
final dio = Dio(
  BaseOptions(
    baseUrl: server_root_url,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 15),
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ),
);
final cacheStore = MemCacheStoreWithTracking();
Future<void> setupDio() async {
  final cacheOptions = CacheOptions(
    store: cacheStore,
    policy: CachePolicy.forceCache,
    maxStale: const Duration(days: 7),
    priority: CachePriority.high,
    hitCacheOnErrorExcept: [401, 403],
  );

  dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Initialize Dependency Injection ──────────────────────
  configureDependencies();

  await setupDio();

  // Cài đặt giao diện
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.black));

  // Khởi tạo Firebase và Notification
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  tz.initializeTimeZones();

  // Khởi tạo giám sát mạng

  // Khởi tạo Hive
  if (!isHiveInitialized) {
    await Hive.initFlutter();
    isHiveInitialized = true;
  }

  // Đăng ký các adapter Hive
  Hive.registerAdapter(FeelingAdapter());
  Hive.registerAdapter(ActivityAdapter());
  Hive.registerAdapter(QuoteAdapter());
  Hive.registerAdapter(DataSyncAdapter());
  Hive.registerAdapter(EntryAdapter());
  Hive.registerAdapter(MoodCheckinAdapter());
  Hive.registerAdapter(DailyChallengeAdapter());
  Hive.registerAdapter(ChallengeAdapter());
  Hive.registerAdapter(HomeModelAdapter());
  Hive.registerAdapter(UserChallengeAdapter());
  Hive.registerAdapter(ReflectionAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.registerAdapter(VoiceNoteAdapter());
  Hive.registerAdapter(UserreflectionAdapter());
  Hive.registerAdapter(PhotoAdapter());
  await Hive.openBox('settings');

  // Lấy cài đặt người dùng từ Hive
  try {
    Repository<int, User> _repo = Repository<int, User>(name: 'user_box');
    await _repo.init();
    User app_setting = await _repo.getAt(0);
    is_darkmode = app_setting.darkmode;
    theme_selected = app_setting.theme_color;
  } catch (e) {
    print(e);
  }

  // Khóa hướng màn hình dọc
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => Navigation_viewmodel()),
          ChangeNotifierProvider(create: (context) => Entries_Viewmodel()),
        ],
        child: MaterialApp(
            // ── New navigation system ──────────────────────
            navigatorKey: AppNavigator.navigatorKey,
            onGenerateRoute: AppRouter.onGenerateRoute,
            // ───────────────────────────────────────────────
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
              fontFamily: 'Google',
            ),
            title: 'My Reflectly',
            home: AnnotatedRegion<SystemUiOverlayStyle>(
              value: is_darkmode
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark,
              child: InitPage(),
            ))));
  });
}