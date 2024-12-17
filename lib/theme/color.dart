import 'package:flutter/material.dart';

class ColorData {
  late Color firstColor;
  late Color secondColor;

  ColorData({required this.firstColor, required this.secondColor});
}

class ColorTheme {
  static List<ColorData> listTheme = [
    ColorData(
      firstColor: const Color.fromARGB(255, 63, 161, 164),
      secondColor: const Color.fromARGB(255, 99, 214, 158),
    ),
  ];
}

double screenWidth_Global = 0;
double screenHeight_Global = 0;
double margin_height_Global = 5;
 List<BoxShadow> my_shadow = [
  BoxShadow(
    color: 
    //all_color[theme_selected][0].withOpacity(0.15),
    Color.fromARGB(20, 0, 0, 0),
    spreadRadius: 0.1,
    blurRadius: 10,
    offset: Offset(0, 10),
  ),
];

double global_radius = 0;
bool dark_mode = false;
const Color background_level2_dark_mode = Color.fromARGB(255, 41, 66, 97);
const Color background_level1_dark_mode = Color.fromARGB(255, 35, 51, 85);