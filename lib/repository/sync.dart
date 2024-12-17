import 'dart:isolate';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:myrefectly/help/enum.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/DIOInterceptor.dart';
import 'package:myrefectly/repository/api_service.dart';
import 'package:myrefectly/repository/repository.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:restart_app/restart_app.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';

enum ActionEnum { Create, Update, Delete }

enum CollectionEnum {
  MoodCheckin,
  DailyChallenge,
  Photo,
  VoiceNote,
  ShareReflection,
  Activity,
  Feeling,
  User,
  Heart
}

class Data_Sync_Trigger {
  static final Data_Sync_Trigger _instance = Data_Sync_Trigger._internal();
  var uuid = Uuid();

  // Private constructor Singleton
  Data_Sync_Trigger._internal();
  final apiService = ApiService(baseUrl: server_root_url);

  factory Data_Sync_Trigger() {
    init_data();
    return _instance;
  }

  static late Repository<String, Data_Sync> _entry_sync_repo;
  static bool _isDataInitialized = false;

  static late User user;
  static late Repository<String, User> _user_repo;

  static Future<void> init_data() async {
    if (!isHiveInitialized) {
      await Hive.initFlutter();
      isHiveInitialized = true;
    }
    _entry_sync_repo = Repository<String, Data_Sync>(name: 'entry_sync_box');
    await _entry_sync_repo.init();
    _user_repo = await Repository<String, User>(name: 'user_box');
    await _user_repo.init();
    user = await _user_repo.getAt(0);
    _isDataInitialized = true; 
  }

  Future<void> syncDataWithServer(Data_Sync data) async {
    if (!_isDataInitialized) {
      await init_data();
    }

    try {
      if (data.id != '####') {
        await _entry_sync_repo.add(data.id, data);
      }

      List<Data_Sync> list = await _entry_sync_repo.getAll();
      List<Map<String, dynamic>> jsonEntries = list
          .map((entry) => {
                'id': entry.id,
                'name': entry.name,
                'action': entry.action,
                'json_data': entry.jsonData,
                'timeStamp': entry.timeStamp.toIso8601String(),
              })
          .toList();

      // ReceivePort nhận dữ liệu từ isolate phụ
      ReceivePort receivePort = ReceivePort();
      // isolate phụ
      await Isolate.spawn(sync_entry,
          [receivePort.sendPort, jsonEntries, refresh_token, access_token]);

      // Lắng nghe kết quả từ isolate phụ
      receivePort.listen((message) {
        if (message == ActionStatus.success) {
          for (var i = 0; i < list.length; i++) {
            _entry_sync_repo.delete(list[i].id);
          }
        } else if (message is New_Token) {
          print(message);
          user.access_token = message.access_token;
          user.refresh_token = message.refresh_token;
          access_token = user.access_token;
          refresh_token = user.refresh_token;
          print("OK");
        } else if (message == -999) {
          force_log_out();
        }
      });
    } catch (e) {
      print('Error in syncDataWithServer: $e');
    }
  }

  static Future<void> sync_entry(List<dynamic> args) async {
    SendPort sendPort = args[0];
    List<Map<String, dynamic>> entries = args[1];
    String refresh_token = args[2];
    String access_token = args[3];

    try {
      String jsonEntries = jsonEncode(entries);

      final dio = Dio(BaseOptions(
        baseUrl: server_root_url,
        connectTimeout: Duration(seconds: 10), // Timeout kết nối
        receiveTimeout: Duration(seconds: 15), // Timeout nhận dữ liệu
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ));
      dio.interceptors.add(TokenInterceptor(
        dio: dio,
        accessToken: access_token,
        refreshToken: refresh_token,
        sendPort: sendPort,
      ));

      final response = await dio.post('/entrysync', data: jsonEntries);

      if (response.statusCode == 200) {
        sendPort.send(ActionStatus.success);
      } else {
        sendPort.send("Đồng bộ thất bại với mã ${response.statusCode}");
      }
    } catch (e) {
      sendPort.send("Lỗi khi gửi dữ liệu: $e");
    }
  }
}

class New_Token {
  String refresh_token;
  String access_token;
  New_Token({required this.access_token, required this.refresh_token});
}

Future<void> force_log_out() async {
  final overlayState =
      navigatorKey.currentState?.overlay; // Lấy OverlayState từ navigatorKey
  if (overlayState == null) return; // Kiểm tra overlay tồn tại

  final overlayEntry = OverlayEntry(
    builder: (context) =>
        NotificationPopup(message: "You are logging in other device"),
  );

  overlayState.insert(overlayEntry); // Thêm notification vào overlay
  // User user;
  // Repository<String, User> _user_repo;
  // _user_repo = await Repository<String, User>(name: 'user_box');
  // await _user_repo.init();
  // user = await _user_repo.getAt(0);
  // user.access_token = "";
  // user.refresh_token = "";
  // user.save();
  await Hive.deleteFromDisk();

  // Xóa popup sau 5 giây
  Future.delayed(Duration(seconds: 3), () async {
    overlayEntry.remove();
    Restart.restartApp();
  });
}


































































// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) async {
//     await Hive.initFlutter();
//     Hive.registerAdapter(EntrySyncAdapter());
//     //final _repo = Repository<String, Entry_Sync>(name: 'entry_sync_box');
//     Box<String> box = await Hive.openBox<String>("entry_sync_box");

//     //await _repo.init();
//     String json = inputData!['data'];
//     print(json);

//     List<Entry_Sync> l = await box.values as List<Entry_Sync>;
//     //await _repo.getAll();
//     String req = jsonEncode(l);
//     //print(l);
//     if (l.length > 0) {
//       try {
//         final response = await http.post(
//           Uri.parse(
//               '${server_root_url}/entrysync'), // Thay thế với URL API của bạn
//           headers: {
//             'Authorization': 'Bearer $refresh_token', // Thêm token vào header
//             'Content-Type': 'application/json',
//           },
//           body: req,
//         );

//         if (response.statusCode == 200) {
//           //await _repo.clearAll();
//           await box.clear();
//           //List<Entry_Sync> l = await _repo.getAll();
//           //print(l);
//         } else {
//           // Xử lý lỗi nếu không thành công
//           print('-----Failed to sync: ${response.statusCode}');
//         }
//       } catch (e) {
//         print('Error: $e'); // In ra lỗi
//       }
//     }

//     return asy.Future.value(true);
//   });
// }
