import 'package:flutter/material.dart';

int theme_selected = 0;
final List<List<Color>> all_color = [
  [
    const Color.fromARGB(255, 138, 130, 200), 
    const Color.fromARGB(255, 130, 137, 229), 
  ],
  [
    const Color.fromARGB(255, 255, 156, 156), 
    const Color.fromARGB(255, 255, 205, 165),
  ],
  [
    const Color(0xFF657DE9), 
    const Color(0xFF5C5EDD), // Deep Blue
  ],
  [
    const Color(0xFF6F72CA), // Soft Purple
    const Color(0xFF1E1466), // Deep Purple
  ],
  [
    const Color(0xFFFE95B6), // Pink Coral
    const Color(0xFFFF5287), // Bright Pink
  ],
  [
    const Color(0xFF738AE6), // Light Sky Blue
    const Color(0xFF5C5EDD), // Soft Purple
  ],
  [
    const Color.fromARGB(255, 245, 101, 161), // Light Sky Blue
    const Color.fromARGB(255, 254, 115, 122), // Soft Purple
  ],
  [
    const Color.fromARGB(255, 0, 181, 213), // Light Sky Blue
    const Color.fromARGB(255, 0, 224, 213), // Soft Purple
  ],
  [
    const Color.fromARGB(255, 61, 155, 171), // Light Sky Blue
    const Color.fromARGB(255, 119, 153, 247), // Soft Purple
  ],
  [
    const Color(0xFF76B2FE), // Light Sky Blue
    const Color(0xFFCA82FF), // Soft Purple
  ],
  [
    const Color.fromARGB(255, 70, 168, 166),
    const Color.fromARGB(255, 99, 208, 161),
  ],
  [
    const Color(0xFF00B4DB), // Sky Blue
    const Color(0xFF0083B0), // Deep Sea Blue
  ],
];
bool is_darkmode = false;
Color background_light = Color.fromARGB(255, 242, 247, 251);
Color background_dark = Color.fromARGB(255, 35, 51, 85);
Color card_dark = Color.fromARGB(255, 41, 66, 97);
Color icon_dark = Color.fromARGB(255, 38, 61, 93);
Color card_normal() {
  return Color.lerp(all_color[theme_selected][0],
      is_darkmode ? Color.fromARGB(255, 41, 66, 97) : Colors.white, 0.925)!;
}
