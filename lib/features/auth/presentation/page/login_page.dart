import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/core/navigation/app_routes.dart';
import 'package:myrefectly/core/theme/app_themes.dart';
import 'package:myrefectly/core/widget/zoom_tap_animation.dart';
import 'package:myrefectly/features/auth/presentation/bloc/login/login_bloc.dart';
import 'package:myrefectly/features/auth/presentation/bloc/login/login_event.dart';
import 'package:myrefectly/features/auth/presentation/bloc/login/login_state.dart';
import 'package:myrefectly/features/auth/presentation/page/forgot_password_page.dart';
import 'package:myrefectly/features/auth/presentation/widget/notification_popup.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/views/navigation/navigation.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          showNotificationPopup(
              context, 'Welcome to Reflectly', Colors.green[400]);
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            );
          });
        } else if (state is LoginFailure) {
          showNotificationPopup(context, state.message);
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            // ── Background gradient ──────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: all_color[theme_selected],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // ── Content ─────────────────────────────────
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.1,
                    right: screenWidth * 0.1,
                    top: screenHeight * 0.1,
                  ),
                  child: Text(
                    'Account\nLogin',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenWidth * 0.11,
                      color: Colors.black.withOpacity(0.1),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Expanded(child: SizedBox()),

                // ── Email input ───────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Custom_Input(
                    onChanged: (value) => _email = value,
                    limit: 40,
                    hint: 'Email',
                    fontsize: screenWidth * 0.04,
                    viewing: false,
                    need_helper: false,
                  ),
                ),

                // ── Password input ────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Custom_Input(
                    onChanged: (value) => _password = value,
                    limit: 40,
                    hint: 'Password',
                    fontsize: screenWidth * 0.04,
                    is_password: true,
                    viewing: false,
                    need_helper: false,
                  ),
                ),

                // ── Forgot password link ──────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () => _showResetPasswordDialog(context),
                        child: Text(
                          'FORGOT?',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Expanded(child: SizedBox()),

                // ── Sign in button ────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                  child: BlocBuilder<LoginBloc, LoginState>(
                    builder: (context, state) {
                      final isLoading = state is LoginLoading;
                      return SZoomTap(
                        onTap: () {
                          if (!isLoading) {
                            context.read<LoginBloc>().add(
                                  LoginSubmitted(
                                    email: _email,
                                    password: _password,
                                  ),
                                );
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.25,
                            vertical: screenWidth * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(1000),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                'SIGN IN',
                                style: TextStyle(
                                  color: !isLoading
                                      ? all_color[theme_selected][0]
                                      : Colors.transparent,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Second',
                                ),
                              ),
                              AnimatedOpacity(
                                duration: Duration.zero,
                                opacity: isLoading ? 1 : 0,
                                child: AnimatedRotation(
                                  turns: isLoading ? 0 : -1000000,
                                  duration: const Duration(seconds: 500000),
                                  curve: Curves.linear,
                                  child: SvgPicture.asset(
                                    'assets/ico/reload.svg',
                                    colorFilter: ColorFilter.mode(
                                      all_color[theme_selected][0],
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // ── Terms text ────────────────────────────
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.25,
                    vertical: screenWidth * 0.02,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    'By signing in, you have agreed to our term of service and privacy policy',
                    style: TextStyle(
                      fontSize: screenWidth * 0.02,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),

            // ── Back button ───────────────────────────────
            AnimatedPositioned(
              duration: const Duration(milliseconds: 250),
              child: Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: screenWidth * 0.25,
                    left: screenWidth * 0.05,
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: SvgPicture.asset(
                      'assets/ico/arrow_back.svg',
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: const Duration(milliseconds: 300),
      transitionBuilder: (context, animation1, animation2, child) {
        final curvedValue = Curves.easeInOut.transform(animation1.value) - 1.2;
        return Transform.translate(
          offset: Offset(0, -curvedValue * 100),
          child: Opacity(
            opacity: animation1.value,
            child: child,
          ),
        );
      },
      pageBuilder: (context, animation1, animation2) {
        return const ResetPasswordDialog();
      },
    );
  }
}
