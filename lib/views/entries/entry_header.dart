import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Đảm bảo đã import thư viện này
import 'package:myrefectly/help/color.dart';
import 'package:myrefectly/help/effect.dart';
import 'package:myrefectly/models/data.dart';
import 'package:myrefectly/theme/color.dart';

class EntryHeader extends StatefulWidget {
  final double paddingWidth; // Để truyền padding vào nếu cần
  final bool isDarkMode; // Biến để kiểm tra chế độ tối
  List<int> data;
  EntryHeader(
      {Key? key,
      required this.paddingWidth,
      required this.isDarkMode,
      required this.data})
      : super(key: key);

  @override
  _EntryHeaderState createState() => _EntryHeaderState();
}

class _EntryHeaderState extends State<EntryHeader> {
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: screenWidth * 0.075, vertical: 30),
      margin: EdgeInsets.symmetric(
          vertical: widget.paddingWidth * 0.75,
          horizontal: widget.paddingWidth),
      decoration: BoxDecoration(
        color: widget.isDarkMode ? card_dark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: my_shadow,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildStatItem(screenWidth, "assets/ico/message.svg", "reflections",
              widget.data[0]),
          buildStatItem(screenWidth, mood[3]!, "check-ins", widget.data[1]),
          buildStatItem(
              screenWidth, "assets/ico/photo.svg", "photos", widget.data[2]),
        ],
      ),
    );
  }

  Widget buildStatItem(
      double screenWidth, String assetPath, String label, int targetNumber) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset(
          assetPath,
          height: screenWidth * 0.15,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.03),
            BlendMode.srcIn,
          ),
        ),
        Column(
          children: [
            AnimatedCounter(
              targetNumber: targetNumber,
              textStyle: TextStyle(
                fontFamily: "Second",
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.05,
                color: widget.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: widget.isDarkMode
                    ? Colors.white
                    : Colors.black.withOpacity(0.3),
                fontSize: screenWidth * 0.03,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
