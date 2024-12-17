import 'package:flutter/material.dart';

class FadeTransitionPage extends StatelessWidget {
  final PageController controller;
  final int index;
  final Widget child;

  const FadeTransitionPage({
    super.key,
    required this.controller,
    required this.index,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        double page = 0.0;

        try {
          page = controller.page!;
        } catch (e) {}

        double opacity = (1 - ((page - index).abs() * 2)).clamp(0.3, 1.0);
        return Opacity(
          opacity: opacity,
          child: child,
        );
      },
      child: child,
    );
  }
}
