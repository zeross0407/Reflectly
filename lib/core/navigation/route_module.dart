import 'package:myrefectly/core/navigation/app_routes.dart';

/// Base class for feature route modules.
///
/// Each feature implements this to register its own routes.
/// This keeps route definitions co-located with the feature code
/// instead of cluttering a single monolithic router file.
///
/// ## How to use
///
/// 1. Create a route module in your feature:
/// ```dart
/// class AuthRouteModule extends RouteModule {
///   @override
///   Map<String, RouteConfig> get routes => {
///     AppRoutes.login: RouteConfig(
///       builder: (settings) => BlocProvider(
///         create: (_) => sl<LoginBloc>(),
///         child: const LoginPage(),
///       ),
///     ),
///   };
/// }
/// ```
///
/// 2. Register it in `app_route_modules.dart`:
/// ```dart
/// static final modules = <RouteModule>[
///   AuthRouteModule(),
///   HomeRouteModule(),
/// ];
/// ```
abstract class RouteModule {
  /// Returns a map of route name → route config for this feature.
  Map<String, RouteConfig> get routes;
}
