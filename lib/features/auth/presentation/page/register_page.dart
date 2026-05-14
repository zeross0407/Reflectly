import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restart_app/restart_app.dart';

import 'package:myrefectly/core/widget/screen.dart';
import 'package:myrefectly/core/widget/zoom_tap_animation.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/core/theme/app_themes.dart';

import 'package:myrefectly/features/auth/presentation/bloc/register/register_bloc.dart';
import 'package:myrefectly/features/auth/presentation/bloc/register/register_event.dart';
import 'package:myrefectly/features/auth/presentation/bloc/register/register_state.dart';
import 'package:myrefectly/features/auth/presentation/widget/notification_popup.dart';

class RegisterPage extends StatefulWidget {
  final String username;

  const RegisterPage({super.key, required this.username});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with TickerProviderStateMixin {
  String _email = '';
  String _password = '';
  String _retypePassword = '';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          showNotificationPopup(
              context, 'Register Successfully', Colors.green[400]);
          Future.delayed(const Duration(seconds: 1), () {
            Restart.restartApp();
          });
        } else if (state is RegisterFailure) {
          showNotificationPopup(context, state.message, Colors.red[400]);
        }
      },
      child: SScreen(
        child: Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: all_color[theme_selected],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.1,
                      right: screenWidth * 0.1,
                      top: screenHeight * 0.1,
                    ),
                    child: Text(
                      'Account\nRegister',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: screenWidth * 0.11,
                        color: Colors.black.withOpacity(0.1),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Expanded(child: SizedBox()),

                  // ── Email ──────────────────────────────────
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) => _email = value,
                      limit: 100,
                      hint: 'Email',
                      fontsize: screenWidth * 0.04,
                      viewing: false,
                      need_helper: false,
                    ),
                  ),

                  // ── Password ───────────────────────────────
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
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

                  // ── Retype Password ────────────────────────
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) => _retypePassword = value,
                      limit: 40,
                      hint: 'Retype Password',
                      fontsize: screenWidth * 0.04,
                      is_password: true,
                      viewing: false,
                      need_helper: false,
                    ),
                  ),

                  const Expanded(child: SizedBox()),

                  // ── Register button ────────────────────────
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                    child:
                        BlocBuilder<RegisterBloc, RegisterState>(
                      builder: (context, state) {
                        final isLoading = state is RegisterLoading;
                        return SZoomTap(
                          onTap: () {
                            if (isLoading) return;

                            // Client-side validation
                            if (_password.length < 8 ||
                                _password != _retypePassword) {
                              showNotificationPopup(
                                context,
                                'Email or password error',
                                Colors.red[400],
                              );
                              return;
                            }

                            context.read<RegisterBloc>().add(
                                  RegisterSubmitted(
                                    email: _email,
                                    password: _password,
                                    username: widget.username,
                                  ),
                                );
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
                                  'REGISTER',
                                  style: TextStyle(
                                    fontSize: screenWidth * 0.03,
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
                                    duration:
                                        const Duration(seconds: 500000),
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

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.25,
                      vertical: screenWidth * 0.02,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      'By register, you have agreed to our term of service and privacy policy',
                      style: TextStyle(
                        fontSize: screenWidth * 0.02,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
