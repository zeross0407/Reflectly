import 'package:flutter/material.dart';

class SScreen extends StatelessWidget {
  final Widget child;
  const SScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(top: false, child: child);
  }
}
