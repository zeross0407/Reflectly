import 'package:flutter/material.dart';

// // phần lịch indicator của trang home
// Widget calendar_element(String dOfW, String dOfM, bool isPressing) {
//   return Container(
//     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//     decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(15),
//         color: isPressing
//             ? const Color.fromARGB(17, 0, 0, 0)
//             : Colors.transparent),
//     child: Column(
//       children: [
//         Text(
//           dOfW,
//           style: const TextStyle(
//               color: Colors.white, fontWeight: FontWeight.normal, fontSize: 14),
//         ),
//         Text(
//           dOfM,
//           style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.w700,
//               fontSize: 16,
//               fontFamily: "Second"),
//         ),
//       ],
//     ),
//   );
// }

class Calendar_element extends StatefulWidget {
  final String dOfW;
  final DateTime dOfM;
  final bool isPressing;
  final int? index;
  final double? fontsize;
  const Calendar_element(
      {super.key,
      required this.dOfW,
      required this.dOfM,
      required this.isPressing,
      this.index,
      this.fontsize});
  @override
  State<StatefulWidget> createState() => Calendar_element_State();
}

class Calendar_element_State extends State<Calendar_element> {
  DateTime today = DateTime.now();
  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: widget.fontsize! * 1.1, vertical: widget.fontsize! * 0.7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.fontsize! * 1.1),
          color: widget.isPressing
              ? const Color.fromARGB(17, 0, 0, 0)
              : Colors.transparent),
      child: Column(
        children: [
          Text(
            widget.dOfW,
            style: TextStyle(
                color: widget.dOfM.isBefore(today)
                    ? Colors.white
                    : Colors.white.withOpacity(0.5),
                fontWeight: FontWeight.normal,
                fontSize: widget.fontsize),
          ),
          Text(
            ((widget.dOfM.day < 10 ? "0" : "") + widget.dOfM.day.toString()),
            style: TextStyle(
                color: widget.dOfM.isBefore(today)
                    ? Colors.white
                    : Colors.white.withOpacity(0.25),
                fontWeight: FontWeight.w700,
                fontSize: widget.fontsize! * 1.4,
                fontFamily: "Second"),
          ),
        ],
      ),
    );
  }
}
