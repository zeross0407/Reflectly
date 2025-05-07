import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/views/login/login_viewmodel.dart';
import 'package:myrefectly/views/login/forgot_password.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';

class Login_Page extends StatefulWidget {
  const Login_Page({super.key});

  @override
  Login_Page_State createState() => Login_Page_State();
}

class Login_Page_State extends State<Login_Page> with TickerProviderStateMixin {
  List<Color> current_color = [];
  List<Color> next_color = [];
  bool flag = true;
  bool routing = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (routing) {}
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return ChangeNotifierProvider<Login_Viewmodel>(
        create: (context) => Login_Viewmodel(),
        child: Consumer<Login_Viewmodel>(builder: (context, view_model, child) {
          // if (view_model.action == ActionStatus.success) {

          //   return Container();
          // }
          return Scaffold(
            body: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: all_color[theme_selected],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter)),
                ),
                Column(children: [
                  //Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.1,
                        right: screenWidth * 0.1,
                        top: screenHeight * 0.1),
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) {
                        view_model.email = value;
                      },
                      limit: 40,
                      hint: "Email",
                      fontsize: screenWidth * 0.04,
                      viewing: false,
                      need_helper: false,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) {
                        view_model.password = value;
                      },
                      limit: 40,
                      hint: "Password",
                      fontsize: screenWidth * 0.04,
                      is_password: true,
                      viewing: false,
                      need_helper: false,
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
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
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Expanded(child: SizedBox()),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth * 0.15,
                      right: screenWidth * 0.15,
                    ),
                    child: CustomElement(
                      onTap: () async {
                        int code = await view_model.request_login();
                        if (code == -1) {
                          showNotification(
                              context, "Email or password error", null);
                        } else if (code == 1) {
                          showNotification(context, "Welcome to Reflectly",
                              Colors.green[400]);
                          Future.delayed(
                            Duration(milliseconds: 500),
                            () {
                              Restart.restartApp();
                            },
                          );

                          // Provider.of<Navigation_viewmodel>(context,
                          //         listen: false)
                          //     .page = 0;
                          // await Navigator.pushAndRemoveUntil(
                          //   context,
                          //   Slide_up_Route(secondPage: InitPage()),
                          //   (route) =>
                          //       false, // Xóa tất cả các màn hình trước đó
                          // );
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.25,
                              vertical: screenWidth * 0.04),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(1000)),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                "SIGN IN",
                                style: TextStyle(
                                    color: !view_model.logging_in
                                        ? all_color[theme_selected][0]
                                        : Colors.transparent,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Second"),
                              ),
                              AnimatedOpacity(
                                duration: Duration(microseconds: 0),
                                opacity: view_model.logging_in ? 1 : 0,
                                child: AnimatedRotation(
                                  turns: view_model.logging_in
                                      ? 0
                                      : -1000000, // Quay một vòng (360 độ)
                                  duration: Duration(
                                      seconds:
                                          500000), // Thời gian cho một vòng quay
                                  curve: Curves.linear, // Đường cong quay
                                  child: SvgPicture.asset(
                                    "assets/ico/reload.svg",
                                    colorFilter: ColorFilter.mode(
                                        all_color[theme_selected][0],
                                        BlendMode.srcIn),
                                  ), // Đường dẫn tới file SVG của bạn
                                ),
                              )
                            ],
                          )),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.25,
                        vertical: screenWidth * 0.02),
                    child: Text(
                      textAlign: TextAlign.center,
                      "By signing in , you have agree to our term of service and privacy policy",
                      style: TextStyle(
                          fontSize: screenWidth * 0.02, color: Colors.white),
                    ),
                  )
                ]),
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 250),
                  //left: step == 0 ? -50 : 0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                        padding: EdgeInsets.only(
                            top: screenWidth * 0.25, left: screenWidth * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: SvgPicture.asset(
                            "assets/ico/arrow_back.svg",
                            color: Colors.white.withOpacity(0.5),
                          ),
                        )),
                  ),
                ),
              ],
            ),
          );
        }));
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

class NotificationPopup extends StatefulWidget {
  final String message;
  Color? background_color;

  NotificationPopup({Key? key, required this.message, this.background_color})
      : super(key: key);

  @override
  _NotificationPopupState createState() => _NotificationPopupState();
}

class _NotificationPopupState extends State<NotificationPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Tạo CurvedAnimation để áp dụng curve
    final curve = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut, // Bạn có thể thay đổi curve ở đây
    );

    // Tween để điều chỉnh vị trí
    _animation = Tween<double>(begin: -100, end: 50).animate(curve)
      ..addListener(() {
        setState(() {}); // Cập nhật lại trạng thái khi animation thay đổi
      });

    _controller.forward(); // Bắt đầu animation

    // Xóa popup sau 2 giây
    Future.delayed(Duration(seconds: 2), () {
      _controller.reverse(); // Reverse animation
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Giải phóng controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Positioned(
      top: _animation.value, // Sử dụng giá trị animation
      //left: MediaQuery.of(context).size.width / 2 - 100,
      child: Material(
        color: Colors.transparent,
        child: Container(
          alignment: Alignment.center,
          width: screenWidth * 0.8,
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenWidth * 0.04),
          margin: EdgeInsets.symmetric(horizontal: 40.0),
          decoration: BoxDecoration(
            color: widget.background_color ??
                const Color.fromARGB(255, 221, 101, 93),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              textAlign: TextAlign.center,
              widget.message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: screenWidth * 0.04,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
