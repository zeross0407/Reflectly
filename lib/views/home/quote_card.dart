import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/share/button.dart';
import 'package:myrefectly/theme/color.dart';
import 'package:myrefectly/views/navigation/navigation_viewmodel.dart';
import 'package:provider/provider.dart';

class Quote_Card extends StatefulWidget {
  final int index;
  final String text;
  const Quote_Card({super.key, required this.index, required this.text});

  @override
  State<Quote_Card> createState() => _Quote_CardState();
}

class _Quote_CardState extends State<Quote_Card> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    return CustomElement(
      onTap: () {
        Provider.of<Navigation_viewmodel>(context, listen: false).go_to(1);
      },
      child: Container(
        height: screenWidth * 0.6,
        decoration: BoxDecoration(boxShadow: my_shadow),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: Image.asset(
                  "assets/quote_backgrounds/${widget.index + 1}.webp",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                    color: all_color[theme_selected][0].withOpacity(0.2),
                    borderRadius: BorderRadius.circular(22))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: Center(
                child: Text(
                  widget.text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: screenWidth * 0.035),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                padding: EdgeInsets.all(screenWidth * 0.02),
                margin: EdgeInsets.all(screenWidth * 0.04),
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02)),
                child: SvgPicture.asset(
                  "assets/ico/maximize.svg",
                  colorFilter:
                      const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
