import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myrefectly/core/navigation/app_navigator.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/sync.dart';
import 'package:myrefectly/features/auth/presentation/widget/notification_popup.dart';

class NetworkService {
  // Stream để theo dõi trạng thái mạng
  late StreamSubscription<List<ConnectivityResult>> _subscription;

  // Hàm khởi tạo để bắt đầu quan sát
  void startMonitoring() {
    _subscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      // Duyệt qua danh sách các kết quả kết nối
      for (var result in results) {
        if (result == ConnectivityResult.mobile ||
            result == ConnectivityResult.wifi) {
          print("Kết nối mạng khả dụng");

          Data_Sync_Trigger().syncDataWithServer(Data_Sync(
              id: "####",
              name: -1,
              action: -1,
              jsonData: "",
              timeStamp: DateTime.now()));

          _showOverlayNotification("Online Mode", Colors.green[400]);
        } else {
          print("Không có kết nối mạng");
          _showOverlayNotification("Offline Mode", Colors.red[300]);
        }
      }
    });
  }

  /// Shows a notification overlay using the global navigator key.
  void _showOverlayNotification(String message, Color? color) {
    final context = AppNavigator.navigatorKey.currentContext;
    if (context == null) return;
    showNotificationPopup(context, message, color);
  }

  void stopMonitoring() {
    _subscription.cancel();
  }
}
