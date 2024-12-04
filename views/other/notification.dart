import 'package:flutter/material.dart';
import 'package:myrefectly/views/login/login.dart';

Future<void> show_notification(
    BuildContext context, String mess, Color color) async {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) =>
        NotificationPopup(background_color: color, message: mess),
  );

  overlay.insert(overlayEntry);

  // Xóa popup sau 2 giây
  Future.delayed(Duration(seconds: 4), () {
    overlayEntry.remove();
  });
}
