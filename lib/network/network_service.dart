import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:myrefectly/main.dart';
import 'package:myrefectly/models/entity.dart';
import 'package:myrefectly/repository/sync.dart';
import 'package:myrefectly/views/login/login.dart';

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

          final overlayState = navigatorKey.currentState?.overlay;
          if (overlayState == null) return;
          final overlayEntry = OverlayEntry(
            builder: (context) => NotificationPopup(
              message: "Online Mode",
              background_color: Colors.green[400],
            ),
          );
          overlayState.insert(overlayEntry); //
          Future.delayed(Duration(seconds: 3), () async {
            overlayEntry.remove();
          });
        } else {
          print("Không có kết nối mạng");

          final overlayState = navigatorKey.currentState?.overlay;
          if (overlayState == null) return;
          final overlayEntry = OverlayEntry(
            builder: (context) => NotificationPopup(
              message: "Offline Mode",
            ),
          );
          overlayState.insert(overlayEntry); //
          Future.delayed(Duration(seconds: 3), () async {
            overlayEntry.remove();
          });
        }
      }
    });
  }

  void stopMonitoring() {
    _subscription.cancel();
  }
}
