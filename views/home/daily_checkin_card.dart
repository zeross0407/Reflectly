import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/models/data.dart';

class DailyCheckInCard extends StatelessWidget {
  final bool isDarkMode;
  final double screenWidth;
  final List<List<Color>> allColor;
  final int themeSelected;
  final List<BoxShadow> myShadow;
  final VoidCallback onTap;

  const DailyCheckInCard({
    Key? key,
    required this.isDarkMode,
    required this.screenWidth,
    required this.allColor,
    required this.themeSelected,
    required this.myShadow,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? card_dark : Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: myShadow,
        ),
        margin: EdgeInsets.only(bottom: screenWidth * 0.05),
        child: Stack(
          children: [
            Container(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(screenWidth * 0.01),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.025),
                          color: Colors.black.withOpacity(0.025),
                        ),
                        child: SvgPicture.asset(
                          mood[2]!,
                          colorFilter: ColorFilter.mode(
                            allColor[themeSelected][0],
                            BlendMode.srcIn,
                          ),
                          height: screenWidth * 0.05,
                        ),
                      ),
                      Text(
                        "  DAILY CHECK-IN",
                        style: TextStyle(
                          fontFamily: "Second",
                          color: isDarkMode
                              ? Colors.white
                              : Colors.black.withOpacity(0.25),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth * 0.1),
                  Text(
                    "How are you feeling today?",
                    style: TextStyle(
                      color: isDarkMode
                          ? Colors.white
                          : Colors.black.withOpacity(0.25),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              right: -screenWidth * 0.075,
              bottom: -screenWidth * 0.075,
              child: SvgPicture.asset(
                mood[4]!,
                height: screenWidth * 0.3,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(isDarkMode ? 0.1 : 0.05),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
