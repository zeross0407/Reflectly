import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/help/route.dart';
import 'package:myrefectly/main.dart';
import 'package:myrefectly/views/navigation/navigation.dart';
import 'package:myrefectly/help/color.dart';

class SecurityRequest_Page extends StatelessWidget {
  final bool open_app;

  const SecurityRequest_Page({super.key, required this.open_app});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: all_color[theme_selected])),
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () async {
                  bool didAuthenticate = await auth.authenticate(
                      localizedReason: 'Please authenticate',
                      options:
                          const AuthenticationOptions(biometricOnly: true));
                  if (didAuthenticate) {
                    Navigator.pop(context);
                  }
                  if (open_app) {
                    Navigator.push(
                        context, Slide_up_Route(secondPage: NavigationPage()));
                  }
                },
                child: Stack(alignment: Alignment.center, children: [
                  SpreadOutEffect(),
                  SvgPicture.asset(
                    'assets/ico/fingerprint.svg',
                    height: screenWidth * 0.3,
                    colorFilter:
                        ColorFilter.mode(Colors.white, BlendMode.srcIn),
                  ),
                ]),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: screenWidth * 0.05),
                child: Text(
                  'Please authenticate to access Reflectly',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
