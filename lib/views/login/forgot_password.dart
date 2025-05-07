import 'package:flutter/material.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/views/login/forgot_password_viewmodel.dart';
import 'package:myrefectly/views/other/notification.dart';
import 'package:provider/provider.dart';

class ResetPasswordDialog extends StatefulWidget {
  const ResetPasswordDialog({Key? key}) : super(key: key);

  @override
  State<ResetPasswordDialog> createState() => _ResetPasswordDialogState();
}

class _ResetPasswordDialogState extends State<ResetPasswordDialog> {
  final PageController _controller = PageController(initialPage: 0);

  void _nextPage() {
    _controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  int step = 0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(
      () {
        setState(() {
          step = (_controller.page ?? 0).toInt();
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return ChangeNotifierProvider<ForgotPassword_Viewmodel>(
        create: (context) => ForgotPassword_Viewmodel(),
        child: Consumer<ForgotPassword_Viewmodel>(
            builder: (context, view_model, child) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: Text(
              "RESET PASSWORD",
              style: TextStyle(
                  fontFamily: "Google",
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 22),
              textAlign: TextAlign.center,
            ),
            contentPadding: EdgeInsets.all(0),
            content: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              height: step == 0 ? screenWidth * 0.6 : screenWidth * 0.9,
              width: screenWidth * 0.8,
              child: PageView(
                controller: _controller,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Enter your email, we will send you passcode to reset password\n\nYour password is not immediately reset by this action",
                          textAlign: TextAlign.start,
                          style: TextStyle(fontFamily: "Google"),
                        ),
                        SizedBox(height: 20),
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              view_model.email = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Email...',
                              hintStyle: TextStyle(fontFamily: "Google"),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            style: TextStyle(fontFamily: "Google"),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Column(
                      //mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Please check your email, we'll send you code",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontFamily: "Google",
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        Flexible(
                          child: TextField(
                            onChanged: (value) {
                              view_model.code = value;
                            },
                            decoration: InputDecoration(
                              hintText: 'Code...',
                              hintStyle: TextStyle(fontFamily: "Google"),
                              border: InputBorder.none,
                              filled: true,
                              fillColor: Colors.grey[200],
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 20),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            style: TextStyle(fontFamily: "Google"),
                          ),
                        ),
                        SizedBox(
                          height: screenWidth * 0.04,
                        ),
                        TextField(
                          onChanged: (value) {
                            view_model.new_password = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'New password...',
                            hintStyle: TextStyle(fontFamily: "Google"),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          style: TextStyle(fontFamily: "Google"),
                        ),
                        SizedBox(
                          height: screenWidth * 0.04,
                        ),
                        TextField(
                          onChanged: (value) {
                            view_model.retype = value;
                          },
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Retype password...',
                            hintStyle: TextStyle(fontFamily: "Google"),
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Colors.grey[200],
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 20),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadius.circular(7),
                            ),
                          ),
                          style: TextStyle(fontFamily: "Google"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.close)),
              SizedBox(width: screenWidth * 0.1),
              GestureDetector(
                onTap: () async {
                  if (_controller.page == 0) {
                    int rs = await view_model.request_code();
                    if (rs == 1) {
                      _nextPage();
                    }
                  } else if (_controller.page == 1) {
                    int rs = await view_model.change_password();
                    if (rs == 1) {
                      show_notification(
                          context, "Password changed", Colors.green[400]!);
                      Navigator.pop(context);
                    }
                  }
                },
                child: view_model.requesting
                    ? RotatingSvgIcon()
                    : Icon(Icons.check),
              ),
            ],
          );
        }));
  }
}
