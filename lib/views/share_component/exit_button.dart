import 'package:flutter/material.dart';
import 'package:myrefectly/share/button.dart';

Widget exit_button(BuildContext context, darkmode) {
  double screenWidth = MediaQuery.sizeOf(context).width;
  double screenHeight = MediaQuery.sizeOf(context).height;
  return CustomElement(
    onTap: () {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
    },
    child: Container(
      width: screenWidth * 115 / 1028,
      height: screenWidth * 115 / 1028,
      //padding: EdgeInsets.all(screenWidth * 0.025),
      decoration: BoxDecoration(
          color: darkmode
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(screenWidth * 0.035)),
      child: Center(
          child: Icon(
        Icons.close,
        color: darkmode ? Colors.white : Colors.black.withOpacity(0.5),
      )),
    ),
  );
}
