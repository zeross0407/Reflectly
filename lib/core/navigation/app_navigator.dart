import 'package:flutter/material.dart';

import 'app_transitions.dart';

/// Global navigation service — navigate from **anywhere** without [BuildContext].
///
/// Useful for navigating from:
/// - BLoC / Cubit
/// - Services / repositories
/// - Push notification handlers
/// - Deep link handlers
///
/// ## Setup (in MaterialApp)
/// ```dart
/// MaterialApp(
///   navigatorKey: AppNavigator.navigatorKey,
///   onGenerateRoute: AppRouter.onGenerateRoute,
/// )
/// ```
///
/// ## Usage
/// ```dart
/// // Push named route
/// AppNavigator.pushNamed(AppRoutes.login);
///
/// // Push with arguments
/// AppNavigator.pushNamed(AppRoutes.entryDetail, arguments: entryId);
///
/// // Push with custom transition (bypass onGenerateRoute)
/// AppNavigator.push(
///   AppTransitions.scale(page: DetailPage()),
/// );
///
/// // Replace current screen
/// AppNavigator.pushReplacementNamed(AppRoutes.home);
///
/// // Clear stack and go to root
/// AppNavigator.pushNamedAndRemoveAll(AppRoutes.home);
///
/// // Pop
/// AppNavigator.pop();
/// AppNavigator.pop(result: myData);
///
/// // Pop until specific route
/// AppNavigator.popUntilNamed(AppRoutes.home);
/// ```
abstract class AppNavigator {
  const AppNavigator._();

  /// Global navigator key — set this on [MaterialApp.navigatorKey].
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Shortcut to the current navigator state.
  static NavigatorState get _navigator => navigatorKey.currentState!;

  // ── Push ──────────────────────────────────────────────────

  /// Push a named route.
  static Future<T?> pushNamed<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push a custom [Route] (bypass onGenerateRoute).
  static Future<T?> push<T>(Route<T> route) {
    return _navigator.push(route);
  }

  /// Push a widget with a specific transition (convenience method).
  static Future<T?> pushPage<T>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
    Duration? duration,
    String? routeName,
  }) {
    return _navigator.push(
      AppTransitions.buildRoute<T>(
        page: page,
        type: transition,
        duration: duration,
        settings: routeName != null ? RouteSettings(name: routeName) : null,
      ),
    );
  }

  // ── Push Replacement ──────────────────────────────────────

  /// Replace the current route with a named route.
  static Future<T?> pushReplacementNamed<T, TO>(
    String routeName, {
    Object? arguments,
    TO? result,
  }) {
    return _navigator.pushReplacementNamed<T, TO>(
      routeName,
      arguments: arguments,
      result: result,
    );
  }

  /// Replace with a widget + transition.
  static Future<T?> pushReplacementPage<T, TO>(
    Widget page, {
    TransitionType transition = TransitionType.slideUp,
    TO? result,
  }) {
    return _navigator.pushReplacement(
      AppTransitions.buildRoute<T>(page: page, type: transition),
      result: result,
    );
  }

  // ── Push and Remove ───────────────────────────────────────

  /// Push named route and remove all previous routes.
  /// Use for auth flows: login success → go to home, clear stack.
  static Future<T?> pushNamedAndRemoveAll<T>(
    String routeName, {
    Object? arguments,
  }) {
    return _navigator.pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Push a widget and remove all previous routes.
  static Future<T?> pushPageAndRemoveAll<T>(
    Widget page, {
    TransitionType transition = TransitionType.fade,
  }) {
    return _navigator.pushAndRemoveUntil<T>(
      AppTransitions.buildRoute<T>(page: page, type: transition),
      (route) => false,
    );
  }

  // ── Pop ───────────────────────────────────────────────────

  /// Pop the current route.
  static void pop<T>([T? result]) {
    _navigator.pop<T>(result);
  }

  /// Pop until a specific named route.
  static void popUntilNamed(String routeName) {
    _navigator.popUntil(ModalRoute.withName(routeName));
  }

  /// Pop until the first route (root).
  static void popToRoot() {
    _navigator.popUntil((route) => route.isFirst);
  }

  /// Check if we can pop.
  static bool canPop() {
    return _navigator.canPop();
  }

  // ── Context-based helpers ─────────────────────────────────

  /// Push a named route using a [BuildContext] instead of the global key.
  /// Prefer this when you have context available.
  static Future<T?> of<T>(BuildContext context) {
    // This is just a placeholder — use Navigator.of(context) directly.
    throw UnimplementedError(
      'Use Navigator.of(context) for context-based navigation.',
    );
  }
}
