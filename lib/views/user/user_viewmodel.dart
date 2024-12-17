import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myrefectly/help/compress_image.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/help/image_viewer.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/notification/vip.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/repository/sync.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class User_Viewmodel extends ChangeNotifier {
  bool updating = false;
  ActionStatus actionStatus = ActionStatus.waiting;

  ApiService apiService = ApiService(baseUrl: server_root_url + "/api/Account");

  late final ImageFromApi avatar_widget;

  bool loading = true;

  late Repository<String, User> _user_repo;
  late User user;
  String username = "";

  late Repository<String, Activity> _activity_repo;
  late Repository<String, Feeling> _feeling_repo;
  List<Activity> all_activity = [];
  List<Feeling> all_feeling = [];
  User_Viewmodel() {
    _init_data();
    avatar_widget = ImageFromApi(
      need_loading_effect: false,
    );
  }

  Future<void> _init_data() async {
    _activity_repo = await Repository<String, Activity>(name: 'activity_box');
    await _activity_repo.init();

    _feeling_repo = await Repository<String, Feeling>(name: 'feeling_box');
    await _feeling_repo.init();

    _user_repo = await Repository<String, User>(name: 'user_box');
    await _user_repo.init();
    user = await _user_repo.getAt(0);
    username = user.user_name;

    all_activity = await get_activity();
    all_feeling = await get_feeling();

    loading = await false;
    notifyListeners();
  }

  void refresh_UI() async {
    all_activity = await get_activity();
    all_feeling = await get_feeling();
    notifyListeners();
  }

  Future<List<Activity>> get_activity() async {
    List<Activity> l = await _activity_repo.getAll();

    l = l.where((element) {
      return !element.archive;
    }).toList();
    return l;
  }

  Future<List<Feeling>> get_feeling() async {
    List<Feeling> l = await _feeling_repo.getAll();

    l = l.where((element) {
      return !element.archive;
    }).toList();
    return l;
  }

  Future<bool> register_fingerprint() async {
    if (user.passcode) {
      user.passcode = false;
      await user.save();
      notifyListeners();
      return false;
    }

    final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
    final bool canAuthenticate =
        canAuthenticateWithBiometrics || await auth.isDeviceSupported();

    final List<BiometricType> availableBiometrics =
        await auth.getAvailableBiometrics();
    bool didAuthenticate = false;
    if (availableBiometrics.isNotEmpty) {
      // Some biometrics are enrolled.
      try {
        didAuthenticate = await auth.authenticate(
            localizedReason: 'Please authenticate',
            options: const AuthenticationOptions(biometricOnly: true));
      } on PlatformException catch (e) {
        print("Error during authentication: ${e.message}");
      }
    }

    if (availableBiometrics.contains(BiometricType.strong) ||
        availableBiometrics.contains(BiometricType.face)) {
      // Specific types of biometrics are available.
      // Use checks like this with caution!
    }
    user.passcode = didAuthenticate;
    await user.save();
    notifyListeners();
    return didAuthenticate;
  }

  Future<int> update_avatar(File file) async {
    updating = true;
    notifyListeners(); // Cập nhật trạng thái nếu cần

    try {
      // Tạo form data
      Uint8List? webpImage = await compressIMG(file);
      MultipartFile multipartFile = MultipartFile.fromBytes(
        webpImage!,
        filename: path.basenameWithoutExtension(file.path) + '.png',
      );

      FormData formData = FormData.fromMap({
        'file': multipartFile, // Tên key tương ứng với field trong API
      });

      // Gửi request
      Response response = await dio.post(
        '$server_root_url/api/Account/updateavatar',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $refresh_token',
          },
        ),
      );

      if (response.statusCode == 200) {
        print('Avatar updated successfully');
      } else {
        print('Failed to update avatar: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }

    updating = false;
    notifyListeners(); // Cập nhật trạng thái nếu cần

    return 1;
  }

  Future<void> update_name() async {
    if (username == user.user_name) return;
    try {
      user.user_name = username;
      notifyListeners();
      Data_Sync_Trigger().syncDataWithServer(Data_Sync(
          id: uuid.v1(),
          name: CollectionEnum.User.index,
          action: ActionEnum.Update.index,
          jsonData: username,
          timeStamp: DateTime.now()));
    } catch (e) {
      print('Error: $e');
    }
  }

  void setupDailyNotification() {
    try {
      NotificationService.scheduleNotification(
        112,
        "Time to look back",
        "Lets continue write your journey",
        user.time_checkin_reminder,
      );
    } catch (e) {
      print(e);
    }
  }

  List<String> positiveReminders = [
    "You can do it, just take one small step each day!",
    "Remember, you’re stronger than you think.",
    "Every day is a fresh start. Embrace it.",
    "You deserve happiness and success.",
    "Focus on progress, not perfection.",
    "Challenges help you grow stronger.",
    "You’re capable of amazing things.",
    "Take a deep breath, and keep going.",
    "Your hard work will pay off.",
    "Be kind to yourself. You’re doing your best.",
    "Trust the process and believe in yourself.",
    "Celebrate the little wins along the way.",
    "You’re making a difference, even if you don’t see it yet.",
    "Stay positive. Great things are coming.",
    "You can do it, just take one small step each day!",
    "Remember, you’re stronger than you think.",
    "Every day is a fresh start. Embrace it.",
    "You deserve happiness and success.",
    "Focus on progress, not perfection.",
    "Challenges help you grow stronger.",
    "You’re capable of amazing things.",
    "Take a deep breath, and keep going.",
    "Your hard work will pay off.",
    "Be kind to yourself. You’re doing your best.",
    "Trust the process and believe in yourself.",
    "Celebrate the little wins along the way.",
    "You’re making a difference, even if you don’t see it yet.",
    "You can do it, just take one small step each day!",
    "Remember, you’re stronger than you think.",
    "Every day is a fresh start. Embrace it.",
    "You deserve happiness and success.",
    "Focus on progress, not perfection.",
    "Challenges help you grow stronger.",
    "You’re capable of amazing things.",
    "Take a deep breath, and keep going.",
    "Your hard work will pay off.",
    "Be kind to yourself. You’re doing your best.",
    "Trust the process and believe in yourself.",
    "Celebrate the little wins along the way.",
    "You’re making a difference, even if you don’t see it yet.",
  ];

  Future<void> scheduleMultipleNotificationsDaily() async {
    int numberOfNotifications = user.count_positivity_reminder;
    if (numberOfNotifications <= 0) return;
    DateTime startTime = user.start_positivity_reminder;
    DateTime endTime = user.end_positivity_reminder;
    final Duration interval =
        endTime.difference(startTime) ~/ numberOfNotifications;

    for (int i = 0; i < numberOfNotifications; i++) {
      final DateTime scheduledTime = startTime.add(interval * i);

      await NotificationService.scheduleNotification(
        i + 1,
        "Alway Positive",
        positiveReminders[i],
        scheduledTime,
      );
      debugPrint("Scheduled notification ${i + 1} at $scheduledTime");
    }
  }

  Future<void> request_delete_account() async {
    try {
      actionStatus = await ActionStatus.running;
      notifyListeners();
      final response = await dio.post('/api/Account/deleteaccount');
      if (response.statusCode == 200) {
        actionStatus = await ActionStatus.success;
        Future.delayed(
          Duration(milliseconds: 500),
          () async {
            await Hive.deleteFromDisk();
            Restart.restartApp();
          },
        );
      } else {
        print('Failed to make request: ${response.statusCode}');
        actionStatus = await ActionStatus.failure;
      }
    } catch (e) {
      print('Error occurred: $e');
      actionStatus = await ActionStatus.failure;
    }
    notifyListeners();
  }

  Future<int> request_export_entry() async {
    try {
      actionStatus = await ActionStatus.running;
      notifyListeners();
      final response = await dio.post('/api/Account/generate-html');
      if (response.statusCode == 200) {
        actionStatus = await ActionStatus.success;
        notifyListeners();
        return 1;
      } else {
        actionStatus = await ActionStatus.failure;
      }
    } catch (e) {
      actionStatus = await ActionStatus.failure;
    }

    notifyListeners();
    return -1;
  }

  Future<void> sign_out(BuildContext context) async {
    Provider.of<Navigation_viewmodel>(context, listen: false).page = 0;
    await Hive.deleteFromDisk();
    Restart.restartApp();
  }
}
