import 'package:flutter/material.dart';

Text text_intro(
    {String text = "",
    Color color = Colors.white,
    double fontsize = 30,
    String? family}) {
  return Text(text,
      textAlign: TextAlign.center,
      style: TextStyle(
          fontSize: fontsize,
          fontWeight: FontWeight.bold,
          color: color,
          fontFamily: family ?? "Google"));
}
