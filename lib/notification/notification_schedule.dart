// import 'package:flutter/material.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// //import 'package:awesome_notifications/awesome_notifications.dart';

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// class LocalNotificationService {
// // Instance of Flutternotification plugin
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static void initialize() {
//     try {
//       // Initialization setting cho Android
//       const AndroidInitializationSettings initializationSettingsAndroid =
//           AndroidInitializationSettings('app_icon');

//       // Gộp các cài đặt vào InitializationSettings
//       const InitializationSettings initializationSettings =
//           InitializationSettings(
//         android: initializationSettingsAndroid,
//       );

//       flutterLocalNotificationsPlugin.initialize(
//         initializationSettings,
//         onDidReceiveNotificationResponse:
//             (NotificationResponse notificationResponse) {},
//       );
//     } catch (e) {
//       debugPrint("-----------" + e.toString());
//     }
//   }

//   static Future<void> display() async {
//     // To display the notification in device
//     try {
//       //print(message.notification!.android!.sound);
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
//       NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "Channel gjghjghjId", "Main Cgghjghjhannel",
//           groupKey: "gghjbmhmfg",
//           //color: Colors.green,
//           importance: Importance.max,
//           //sound: RawResourceAndroidNotificationSound("gfg"),
//           //playSound: true,
//           priority: Priority.max,
//           //icon: "ic_launcher_round"
//         ),
//       );
//       await _notificationsPlugin.show(
//           id, "Reflectly", "Hi, Welcome back", notificationDetails,
//           payload: "aaaaa");
//     } catch (e) {
//       debugPrint("-----------" + e.toString());
//     }
//   }

//   static Future<void> scheduleDailyNotification(
//       int hour, int minute, String title, String body) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       // Đặt thời gian cho thông báo hàng ngày
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//       final tz.TZDateTime scheduleTime = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         hour,
//         minute,
//       ).isBefore(now)
//           ? tz.TZDateTime(
//               tz.local, now.year, now.month, now.day + 1, hour, minute)
//           : tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

//       NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "daily_channel_id",
//           "Daily Notification Channel",
//           importance: Importance.max,
//           priority: Priority.max,
//         ),
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduleTime,
//         notificationDetails,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time, // Lặp lại hàng ngày
//       );
//       debugPrint("Scheduled notification at $scheduleTime");
//     } catch (e) {
//       debugPrint("Schedule Error: $e");
//     }
//   }

//   static Future<void> scheduleDailyNotificationFromDateTime(
//       DateTime dateTime, String title, String body) async {
//     try {
//       final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

//       // Lấy giờ và phút từ DateTime truyền vào
//       int hour = dateTime.hour;
//       int minute = dateTime.minute;

//       // Lấy thời gian hiện tại
//       final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

//       // Tính thời gian thông báo: nếu thời gian đã qua trong ngày, sẽ chuyển sang ngày hôm sau
//       final tz.TZDateTime scheduleTime = tz.TZDateTime(
//         tz.local,
//         now.year,
//         now.month,
//         now.day,
//         hour,
//         minute,
//       ).isBefore(now)
//           ? tz.TZDateTime(
//               tz.local, now.year, now.month, now.day + 1, hour, minute)
//           : tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

//       NotificationDetails notificationDetails = NotificationDetails(
//         android: AndroidNotificationDetails(
//           "daily_channel_id_from_datetime",
//           "Daily Notification From DateTime",
//           importance: Importance.max,
//           priority: Priority.max,
//         ),
//       );

//       await _notificationsPlugin.zonedSchedule(
//         id,
//         title,
//         body,
//         scheduleTime,
//         notificationDetails,
//         androidAllowWhileIdle: true,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         matchDateTimeComponents: DateTimeComponents.time, // Lặp lại hàng ngày
//       );
//       debugPrint("Scheduled daily notification at $scheduleTime");
//     } catch (e) {
//       debugPrint("Error scheduling notification: $e");
//     }
//   }
// }
