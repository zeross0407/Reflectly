import 'package:flutter/material.dart';

import 'app_transitions.dart';

/// Centralized route definitions for the app.
///
/// All route names live here — no magic strings scattered in code.
/// Update this when adding new screens.
///
/// Usage:
/// ```dart
/// // In onGenerateRoute:
/// case AppRoutes.login:
///   return AppTransitions.slideUp(page: LoginPage(), settings: settings);
///
/// // When navigating:
/// Navigator.pushNamed(context, AppRoutes.login);
/// // or
/// AppNavigator.pushNamed(AppRoutes.login);
/// ```
abstract class AppRoutes {
  const AppRoutes._();

  // ── Root / Init ─────────────────────────────────────────────
  static const String splash = '/';
  static const String init = '/init';
  static const String intro = '/intro';

  // ── Auth ────────────────────────────────────────────────────
  static const String login = '/auth/login';
  static const String register = '/auth/register';

  // ── Main ────────────────────────────────────────────────────
  static const String home = '/home';
  static const String navigation = '/navigation';

  // ── Entries ─────────────────────────────────────────────────
  static const String entries = '/entries';
  static const String entryDetail = '/entries/detail';

  // ── Mood Check-in ───────────────────────────────────────────
  static const String moodCheckin = '/mood-checkin';

  // ── Challenges ──────────────────────────────────────────────
  static const String challenges = '/challenges';
  static const String challengeDetail = '/challenges/detail';

  // ── Quotes ──────────────────────────────────────────────────
  static const String quotes = '/quotes';

  // ── Voice Note ──────────────────────────────────────────────
  static const String voiceNote = '/voice-note';

  // ── Settings ────────────────────────────────────────────────
  static const String settings = '/settings';
  static const String userProfile = '/user-profile';

  // ── Deep Link patterns ──────────────────────────────────────
  // These patterns are used when parsing deep links from push
  // notifications, universal links, etc.
  //
  // Example: reflectly://entries/detail?id=xxx
  //
  // Add parsing logic in [AppRouter.parseDeepLink] when ready.
}

/// Configuration for a single route entry.
///
/// Used by [AppRouter] to define which page to show and
/// which transition to use for each route name.
class RouteConfig {
  /// Builder that creates the page widget.
  /// Receives [RouteSettings] for accessing arguments.
  final Widget Function(RouteSettings settings) builder;

  /// Transition animation to use.
  final TransitionType transition;

  /// Custom transition duration (null = use default).
  final Duration? duration;

  const RouteConfig({
    required this.builder,
    this.transition = TransitionType.slideUp,
    this.duration,
  });
}
