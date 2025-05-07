import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/share/custominp.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/views/login/login.dart';
import 'package:myrefectly/views/login/register_viewmodel.dart';
import 'package:provider/provider.dart';

class Register_Page extends StatefulWidget {
  final String username;
  const Register_Page({super.key, required this.username});

  @override
  Register_Page_State createState() => Register_Page_State();
}

class Register_Page_State extends State<Register_Page>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return ChangeNotifierProvider<Register_Viewmodel>(
        create: (context) => Register_Viewmodel(username: widget.username),
        child:
            Consumer<Register_Viewmodel>(builder: (context, view_model, child) {
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
                  Padding(
                    padding: EdgeInsets.only(
                        left: screenWidth * 0.1,
                        right: screenWidth * 0.1,
                        top: screenHeight * 0.1),
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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) {
                        view_model.email = value;
                      },
                      limit: 100,
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
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    child: Custom_Input(
                      onChanged: (value) {
                        view_model.retype_password = value;
                      },
                      limit: 40,
                      hint: "Retype Password",
                      fontsize: screenWidth * 0.04,
                      is_password: true,
                      viewing: false,
                      need_helper: false,
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
                        int code = await view_model.request_register();
                        if (code == -1) {
                          showNotification(context, "Email or password error",
                              Colors.red[400]);
                        } else if (code == 1) {
                          showNotification(context, "Register Successfully",
                              Colors.green[400]);
                        } else {
                          showNotification(context, "Account Existed",
                              Colors.red[400]);
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
                                "REGISTER",
                                style: TextStyle(
                                    fontSize: screenWidth * 0.03,
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
                      "By register , you have agree to our term of service and privacy policy",
                      style: TextStyle(
                          fontSize: screenWidth * 0.02, color: Colors.white),
                    ),
                  )
                ]),
              ],
            ),
          );
        }));
  }
}
