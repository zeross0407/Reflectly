import 'package:flutter/material.dart';

/// Shows a slide-down notification popup overlay.
///
/// Extracted from the old `login.dart` — now reusable across all pages.
///
/// Usage:
/// ```dart
/// showNotificationPopup(context, 'Welcome!', Colors.green);
/// ```
void showNotificationPopup(
  BuildContext context,
  String message, [
  Color? color,
]) {
  final overlay = Overlay.of(context);
  late OverlayEntry overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => _NotificationPopup(
      message: message,
      backgroundColor: color ?? Colors.red[300]!,
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(const Duration(seconds: 5), () {
    if (overlayEntry.mounted) {
      overlayEntry.remove();
    }
  });
}

class _NotificationPopup extends StatefulWidget {
  final String message;
  final Color backgroundColor;

  const _NotificationPopup({
    required this.message,
    required this.backgroundColor,
  });

  @override
  State<_NotificationPopup> createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<_NotificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _animation = Tween<double>(begin: -100, end: 50).animate(curve)
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Positioned(
      top: _animation.value,
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.05,
            vertical: screenWidth * 0.04,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
