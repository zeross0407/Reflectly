import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/authetication/forgot_password/forgot_password.dart';
import 'package:myrefectly/authetication/login/login.dart';
import 'package:myrefectly/di/injection.dart';
import 'package:myrefectly/features/auth/stores/login_store.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:restart_app/restart_app.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore _loginStore = serviceLocator<LoginStore>();

  @override
  void dispose() {
    _loginStore.reset();
    super.dispose();
  }

  void _showResetPasswordDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 300),
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
        return ResetPasswordDialog();
      },
    );
  }

  void showNotification(BuildContext context, String message, Color? color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => NotificationPopup(
        message: message,
        background_color: color ?? Colors.red[300],
      ),
    );

    overlay.insert(overlayEntry);

    // Xóa popup sau 2 giây
    Future.delayed(Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
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
              Observer(
                builder: (_) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Custom_Input(
                    onChanged: (value) => _loginStore.setEmail(value),
                    limit: 40,
                    hint: "Email",
                    fontsize: screenWidth * 0.04,
                    viewing: false,
                    need_helper: false,
                  ),
                ),
              ),
              Observer(
                builder: (_) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                  child: Custom_Input(
                    onChanged: (value) => _loginStore.setPassword(value),
                    limit: 40,
                    hint: "Password",
                    fontsize: screenWidth * 0.04,
                    is_password: true,
                    viewing: false,
                    need_helper: false,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showResetPasswordDialog(context);
                      },
                      child: Text(
                        "FORGOT?",
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
              Observer(
                builder: (_) => Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.15,
                    right: screenWidth * 0.15,
                  ),
                  child: CustomElement(
                    onTap: () async {
                      if (_loginStore.isLoading) return;

                      final success = await _loginStore.login();
                      if (_loginStore.errorMessage != null) {
                        showNotification(
                          context,
                          _loginStore.errorMessage!,
                          Colors.red[300],
                        );
                      }
                      if (success) {
                        showNotification(
                          context,
                          "Welcome to Reflectly",
                          Colors.green[400],
                        );
                        Future.delayed(
                          Duration(milliseconds: 500),
                          () {
                            Restart.restartApp();
                          },
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
                            "SIGN IN",
                            style: TextStyle(
                              color: !_loginStore.isLoading
                                  ? all_color[theme_selected][0]
                                  : Colors.transparent,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Second",
                            ),
                          ),
                          AnimatedOpacity(
                            duration: Duration(microseconds: 0),
                            opacity: _loginStore.isLoading ? 1 : 0,
                            child: AnimatedRotation(
                              turns: _loginStore.isLoading ? 0 : -1000000,
                              duration: Duration(seconds: 500000),
                              curve: Curves.linear,
                              child: SvgPicture.asset(
                                "assets/ico/reload.svg",
                                colorFilter: ColorFilter.mode(
                                  all_color[theme_selected][0],
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.25,
                  vertical: screenWidth * 0.02,
                ),
                child: Text(
                  textAlign: TextAlign.center,
                  "By signing in, you have agreed to our terms of service and privacy policy",
                  style: TextStyle(
                    fontSize: screenWidth * 0.02,
                    color: Colors.white,
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                top: screenWidth * 0.25,
                left: screenWidth * 0.05,
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: SvgPicture.asset(
                  "assets/ico/arrow_back.svg",
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
