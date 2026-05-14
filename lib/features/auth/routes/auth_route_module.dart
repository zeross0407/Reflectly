import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:myrefectly/core/di/injection.dart';
import 'package:myrefectly/core/navigation/app_routes.dart';
import 'package:myrefectly/core/navigation/app_transitions.dart';
import 'package:myrefectly/core/navigation/route_module.dart';

import 'package:myrefectly/features/auth/presentation/bloc/forgot_password/forgot_password_bloc.dart';
import 'package:myrefectly/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:myrefectly/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:myrefectly/features/auth/presentation/page/login_page.dart';
import 'package:myrefectly/features/auth/presentation/page/register_page.dart';

/// Auth feature route definitions.
///
/// Routes defined here:
/// - `/auth/login`  → LoginPage (with LoginBloc + ForgotPasswordBloc)
/// - `/auth/register` → RegisterPage (with RegisterBloc)
class AuthRouteModule extends RouteModule {
  @override
  Map<String, RouteConfig> get routes => {
        AppRoutes.login: RouteConfig(
          builder: (settings) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => sl<LoginBloc>()),
              BlocProvider(create: (_) => sl<ForgotPasswordBloc>()),
            ],
            child: const LoginPage(),
          ),
          transition: TransitionType.slideUp,
        ),
        AppRoutes.register: RouteConfig(
          builder: (settings) {
            final username = settings.arguments as String? ?? '';
            return BlocProvider(
              create: (_) => sl<RegisterBloc>(),
              child: RegisterPage(username: username),
            );
          },
          transition: TransitionType.slideUp,
        ),
      };
}
