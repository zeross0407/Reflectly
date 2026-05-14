import 'package:flutter/material.dart';

/// Pre-built route transitions for the app.
///
/// Each method returns a [PageRouteBuilder] with a custom animation.
/// Use directly or pass as `transitionType` to [AppRouter].
///
/// ```dart
/// Navigator.push(context, AppTransitions.slideUp(page: MyPage()));
/// Navigator.push(context, AppTransitions.fade(page: MyPage()));
/// Navigator.push(context, AppTransitions.slideLeft(page: MyPage()));
/// ```
///
/// Adding a new transition:
/// 1. Add a static method here
/// 2. Add a corresponding enum value in [TransitionType]
/// 3. Map it in [AppTransitions.buildRoute]
abstract class AppTransitions {
  const AppTransitions._();

  // ── Default durations ─────────────────────────────────────

  static const Duration defaultDuration = Duration(milliseconds: 300);
  static const Duration fastDuration = Duration(milliseconds: 200);
  static const Duration slowDuration = Duration(milliseconds: 500);

  // ── Slide Up (current default, replaces Slide_up_Route) ───

  /// Slide up from bottom with fade — the app's signature transition.
  static Route<T> slideUp<T>({
    required Widget page,
    Duration duration = defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween(
          begin: const Offset(0.0, 0.1),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  // ── Fade ───────────────────────────────────────────────────

  /// Simple fade-in transition.
  static Route<T> fade<T>({
    required Widget page,
    Duration duration = defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  // ── Slide Left (push style) ────────────────────────────────

  /// iOS-style slide from right to left.
  static Route<T> slideLeft<T>({
    required Widget page,
    Duration duration = defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: child,
        );
      },
    );
  }

  // ── Slide Right (back style) ──────────────────────────────

  /// Slide from left to right (reverse navigation feel).
  static Route<T> slideRight<T>({
    required Widget page,
    Duration duration = defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final offsetTween = Tween(
          begin: const Offset(-1.0, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(offsetTween),
          child: child,
        );
      },
    );
  }

  // ── Scale (zoom in) ────────────────────────────────────────

  /// Scale + fade transition — great for dialogs and details.
  static Route<T> scale<T>({
    required Widget page,
    Duration duration = defaultDuration,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween<double>(begin: 0.8, end: 1.0)
            .chain(CurveTween(curve: Curves.easeOutBack));
        final fadeTween = Tween<double>(begin: 0.0, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn));

        return ScaleTransition(
          scale: animation.drive(scaleTween),
          child: FadeTransition(
            opacity: animation.drive(fadeTween),
            child: child,
          ),
        );
      },
    );
  }

  // ── No Animation ──────────────────────────────────────────

  /// Instant transition with no animation.
  static Route<T> none<T>({
    required Widget page,
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
      pageBuilder: (context, animation, secondaryAnimation) => page,
    );
  }

  // ── Builder from enum ─────────────────────────────────────

  /// Build a route from a [TransitionType] enum value.
  /// Used internally by [AppRouter.onGenerateRoute].
  static Route<T> buildRoute<T>({
    required Widget page,
    required TransitionType type,
    Duration? duration,
    RouteSettings? settings,
  }) {
    switch (type) {
      case TransitionType.slideUp:
        return slideUp(
            page: page, duration: duration ?? defaultDuration, settings: settings);
      case TransitionType.fade:
        return fade(
            page: page, duration: duration ?? defaultDuration, settings: settings);
      case TransitionType.slideLeft:
        return slideLeft(
            page: page, duration: duration ?? defaultDuration, settings: settings);
      case TransitionType.slideRight:
        return slideRight(
            page: page, duration: duration ?? defaultDuration, settings: settings);
      case TransitionType.scale:
        return scale(
            page: page, duration: duration ?? defaultDuration, settings: settings);
      case TransitionType.none:
        return none(page: page, settings: settings);
    }
  }
}

/// Available transition types for route navigation.
enum TransitionType {
  slideUp,
  fade,
  slideLeft,
  slideRight,
  scale,
  none,
}
