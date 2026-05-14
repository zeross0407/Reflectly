import 'package:flutter/material.dart';

import 'app_routes.dart';
import 'app_transitions.dart';
import 'route_module.dart';

// ── Feature Route Modules ──────────────────────────────────
import 'package:myrefectly/features/auth/routes/auth_route_module.dart';

// ── Standalone pages (not yet migrated to modules) ─────────
import 'package:myrefectly/views/navigation/navigation.dart';

/// Central route generator for [MaterialApp.onGenerateRoute].
///
/// Routes are **not** defined here directly. Instead, each feature
/// provides a [RouteModule] that registers its own routes.
/// This keeps the router thin and scalable.
///
/// ## Architecture
/// ```
/// AppRouter
///   ├── AuthRouteModule      (login, register)
///   ├── HomeRouteModule       (home, entries, ...)
///   ├── SettingsRouteModule   (settings, profile, ...)
///   └── ... more features
/// ```
///
/// ## Adding routes for a new feature
/// 1. Create `lib/features/<feature>/routes/<feature>_route_module.dart`
/// 2. Implement `RouteModule`
/// 3. Add it to [_modules] list below
/// 4. Done!
class AppRouter {
  const AppRouter._();

  // ── Route Modules ─────────────────────────────────────────
  // Add new feature modules here.
  static final List<RouteModule> _modules = [
    AuthRouteModule(),
    // EntriesRouteModule(),
    // ChallengesRouteModule(),
    // SettingsRouteModule(),
  ];

  // ── Standalone routes (pages not yet in a module) ─────────
  // Move these into feature modules as you migrate.
  static final Map<String, RouteConfig> _standaloneRoutes = {
    AppRoutes.home: RouteConfig(
      builder: (settings) => NavigationPage(),
      transition: TransitionType.fade,
    ),
  };

  /// Merged route map from all modules + standalone routes.
  /// Computed once, cached.
  static late final Map<String, RouteConfig> _routes = _buildRoutes();

  static Map<String, RouteConfig> _buildRoutes() {
    final routes = <String, RouteConfig>{};

    // Collect from all feature modules
    for (final module in _modules) {
      routes.addAll(module.routes);
    }

    // Add standalone routes
    routes.addAll(_standaloneRoutes);

    return routes;
  }

  /// Called by [MaterialApp.onGenerateRoute].
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final config = _routes[settings.name];

    if (config == null) {
      return AppTransitions.fade(
        page: _NotFoundPage(routeName: settings.name ?? 'unknown'),
        settings: settings,
      );
    }

    final page = config.builder(settings);

    return AppTransitions.buildRoute(
      page: page,
      type: config.transition,
      duration: config.duration,
      settings: settings,
    );
  }

  // ── Deep Link Parsing ─────────────────────────────────────

  /// Parse a deep link URI into a route name + arguments.
  ///
  /// ```dart
  /// final (route, args) = AppRouter.parseDeepLink(uri);
  /// AppNavigator.pushNamed(route, arguments: args);
  /// ```
  static (String routeName, Map<String, String> arguments) parseDeepLink(
    Uri uri,
  ) {
    final routeName = '/${uri.pathSegments.join('/')}';
    final arguments = uri.queryParameters;
    return (routeName, arguments);
  }
}

/// 404 page shown when a route is not found.
class _NotFoundPage extends StatelessWidget {
  final String routeName;

  const _NotFoundPage({required this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              'Route not found: $routeName',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
