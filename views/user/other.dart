import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/theme/color.dart';

List<Widget> User_other(double screenWidth, double screenHeight) {
  return [
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 4,
      child: Container(
        margin: EdgeInsets.only(
            bottom: screenWidth * 0.05,
            left: screenWidth * 0.065,
            right: screenWidth * 0.02),
        padding: EdgeInsets.only(
          top: screenWidth * 0.05,
          bottom: screenWidth * 0.05,
          left: screenWidth * 0.065,
        ),
        height: screenWidth * 0.5,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: all_color[theme_selected],
                begin: Alignment.bottomLeft,
                end: Alignment.topRight),
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: my_shadow),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Icon(
                Icons.star_border,
                color: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Rate",
                style: TextStyle(
                    fontSize: screenWidth * 0.12,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Second",
                    color: Colors.black.withOpacity(0.05)),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Rate Reflectly\n5-stars",
                style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Second",
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    ),
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 4,
      child: Container(
        margin: EdgeInsets.only(
            bottom: screenWidth * 0.05,
            right: screenWidth * 0.065,
            left: screenWidth * 0.02),
        padding: EdgeInsets.only(
          top: screenWidth * 0.05,
          bottom: screenWidth * 0.05,
          left: screenWidth * 0.065,
        ),
        height: screenWidth * 0.5,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.04),
            boxShadow: my_shadow),
        child: Stack(
          children: [
            Align(
                alignment: Alignment.topLeft,
                child: SvgPicture.asset(
                  "assets/ico/message.svg",
                  colorFilter: ColorFilter.mode(
                      all_color[theme_selected][0], BlendMode.srcIn),
                )),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Suppo",
                style: TextStyle(
                    fontSize: screenWidth * 0.11,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Second",
                    color: Colors.black.withOpacity(0.05)),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                "Contact Support",
                style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Second",
                    color: Colors.black.withOpacity(0.8)),
              ),
            ),
          ],
        ),
      ),
    ),
  ];
}
