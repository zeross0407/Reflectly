// import 'dart:math';
// import 'package:flutter/material.dart';

// void main() => runApp(const MyApp());

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         backgroundColor: const Color.fromARGB(255, 111, 149, 184),
//         body: Center(
//           //child: TimeSetter(),
//         ),
//       ),
//     );
//   }
// }

// class TimeSetter extends StatefulWidget {
//   int hour;
//   int minute;
//   TimeSetter({required this.hour, required this.minute});
//   @override
//   _TimeSetterState createState() => _TimeSetterState();
// }

// class _TimeSetterState extends State<TimeSetter> {
//   double startAngle = 0; // Góc bắt đầu
//   double endAngle = 1; // Góc kết thúc
//   double minValue = 0;
//   double maxValue = 12;
//   double hours = 0;
//   double minutes = 0;
//   bool point1 = false;
//   bool point2 = false;
//   int point = -1;
//   bool flag = false;
//   double screenWidth = 1;
//   double screenHeight = 1;
// ////////////////////////////////////////////////
//   ///
//   ///
//   ///
//   final int _initialHour =
//       12 * 100; // Bắt đầu từ giữa danh sách giờ (giả lập vô hạn)
//   final int _initialMinute =
//       60 * 100; // Bắt đầu từ giữa danh sách phút (giả lập vô hạn)

//   FixedExtentScrollController? _hourController;
//   FixedExtentScrollController? _minuteController;

//   int selectedHour = 1;
//   int selectedMinute = 0;

//   //////////////////////////////////////////////

//   // Hàm chuyển đổi góc thành giá trị
//   double _angleToValue(double angle) {
//     double percentage = ((angle + pi / 2) / (2 * pi)) % 1;
//     return (percentage * (maxValue - minValue)) + minValue;
//   }

//   // Hàm chuyển đổi góc thành giá trị
//   double _angleToMinutes(double angle) {
//     double percentage = ((angle + pi / 2) / (2 * pi)) % 1;
//     return (percentage * (60 - 0)) + 0;
//   }

//   double roundToNearestDivision(double x, int number_part) {
//     // Chia 2pi thành 60 phần
//     double step = (2 * pi) / number_part;

//     // Xác định chỉ số của phần gần nhất
//     int index = (x / step).round();

//     // Trả về giá trị đã làm tròn khớp với phần chia
//     return index * step;
//   }

//   // Hàm xử lý khi kéo trượt
//   void _onPanUpdate(DragUpdateDetails details) {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     Offset center = Offset(screenWidth * 0.65 / 2, screenWidth * 0.65 / 2);
//     Offset position = details.localPosition - center;

//     double angle = atan2(position.dy, position.dx);

//     // Đảm bảo góc dương
//     if (angle < 0) angle += 2 * pi;

//     //print(angle);
//     //angle = roundToNearestDivision(angle,60);

//     setState(() {
//       if (point == 1) {
//         startAngle = roundToNearestDivision(angle, 60);
//         minutes = _angleToMinutes(startAngle);
//         print(minutes);
//         _minuteController!.animateToItem(minutes.toInt(),
//             duration: Duration(milliseconds: 2), curve: Curves.linear);
//       } else if (point == 2) {
//         endAngle = roundToNearestDivision(angle, 12);
//         hours = _angleToValue(endAngle);
//         print(hours % 12);
//       }
//     });
//   }

//   void _onPanEnd(DragEndDetails details) {
//     point = -1;
//     flag = false;
//   }

//   double roundDouble(double value, int places) {
//     double mod = pow(10.0, places).toDouble();
//     return ((value * mod).round().toDouble() / mod);
//   }

//   void _onPanStart(DragStartDetails details) {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     Offset center = Offset(screenWidth * 0.65 / 2, screenWidth * 0.65 / 2);
//     //renderBox.size.center(Offset.zero);
//     Offset position = details.localPosition - center;

//     double angle = atan2(position.dy, position.dx);
//     // Đảm bảo góc dương
//     if (angle < 0) angle += 2 * pi;
//     double a = roundDouble(angle, 1);
//     double b = roundDouble(endAngle, 1);

//     if ((roundDouble(angle, 1) >= roundDouble(endAngle, 1) - 0.3 &&
//         roundDouble(angle, 1) <= roundDouble(endAngle, 1) + 0.3)) {
//       point = 2;
//       flag = true;
//     } else if (roundDouble(angle, 1) >= roundDouble(startAngle, 1) - 0.3 &&
//         roundDouble(angle, 1) <= roundDouble(startAngle, 1) + 0.3) {
//       point = 1;
//       flag = true;
//     }

//     return;
//   }

//   @override
//   void initState() {
//     super.initState();
//     _hourController = FixedExtentScrollController(initialItem: _initialHour)
//       ..addListener(
//         () {},
//       );
//     _minuteController =
//         FixedExtentScrollController(initialItem: _initialMinute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     screenWidth = MediaQuery.sizeOf(context).width;
//     screenHeight = MediaQuery.sizeOf(context).height;

//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         GestureDetector(
//           onPanUpdate: _onPanUpdate,
//           onPanEnd: _onPanEnd,
//           onPanStart: _onPanStart,
//           child: CustomPaint(
//             size: Size(screenWidth * 0.6, screenWidth * 0.6),
//             painter: CircularSliderPainter(startAngle, endAngle),
//           ),
//         ),
//         ClipOval(
//           child: Container(
//               width: screenWidth * 0.65,
//               height: screenWidth * 0.65,
//               color: Colors.transparent,
//               child: Padding(
//                 padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         // Bộ chọn giờ
//                         Expanded(
//                           child: Container(
//                             //color: Colors.blue,
//                             height: screenWidth * 0.3,
//                             child: Stack(
//                               children: [
//                                 ListWheelScrollView.useDelegate(
//                                   controller: _hourController,
//                                   itemExtent: screenWidth * 0.1,
//                                   physics: const FixedExtentScrollPhysics(),
//                                   onSelectedItemChanged: (int index) {
//                                     if (!flag) {
//                                       //print(index);
//                                       setState(() {
//                                         selectedHour =
//                                             index % 13; // Giới hạn từ 0 đến 23

//                                         endAngle =
//                                             pi * 2 * (index % 12) / 12 - pi / 2;
//                                         ;
//                                         print(selectedHour);
//                                       });
//                                     }
//                                   },
//                                   childDelegate: ListWheelChildBuilderDelegate(
//                                     builder: (context, index) {
//                                       final displayHour = index % 13;
//                                       return Center(
//                                         child: Text(
//                                           (displayHour + 1)
//                                               .toString()
//                                               .padLeft(2, '0'),
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: "Second",
//                                               fontSize: screenWidth * 0.08,
//                                               color: selectedHour == index % 13
//                                                   ? Colors.white
//                                                   : Colors.white
//                                                       .withOpacity(0.25)),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 //_buildFadingEffect(),
//                               ],
//                             ),
//                           ),
//                         ),
//                         Text(
//                           ":",
//                           style: TextStyle(
//                               fontSize: screenWidth * 0.08,
//                               fontWeight: FontWeight.bold,
//                               fontFamily: "Second",
//                               color: Colors.white),
//                         ),
//                         // Bộ chọn phút
//                         Expanded(
//                           child: Container(
//                             height: screenWidth * 0.3,
//                             child: Stack(
//                               children: [
//                                 ListWheelScrollView.useDelegate(
//                                   controller: _minuteController,
//                                   itemExtent: screenWidth * 0.1,
//                                   physics: const FixedExtentScrollPhysics(),
//                                   onSelectedItemChanged: (int index) {
//                                     if (!flag) {
//                                       setState(() {
//                                         selectedMinute =
//                                             index % 60; // Giới hạn từ 0 đến 59
//                                         startAngle =
//                                             pi * 2 * (index % 60) / 60 - pi / 2;
//                                         ;
//                                       });
//                                     }
//                                   },
//                                   childDelegate: ListWheelChildBuilderDelegate(
//                                     builder: (context, index) {
//                                       final displayMinute = index % 60;
//                                       return Center(
//                                         child: Text(
//                                           displayMinute
//                                               .toString()
//                                               .padLeft(2, '0'),
//                                           style: TextStyle(
//                                               fontWeight: FontWeight.bold,
//                                               fontFamily: "Second",
//                                               fontSize: screenWidth * 0.08,
//                                               color:
//                                                   selectedMinute == index % 60
//                                                       ? Colors.white
//                                                       : Colors.white
//                                                           .withOpacity(0.25)),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 //_buildFadingEffect(),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               )),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _hourController?.dispose();
//     _minuteController?.dispose();
//     super.dispose();
//   }
// }

// class CircularSliderPainter extends CustomPainter {
//   final double startAngle;
//   final double endAngle;

//   CircularSliderPainter(this.startAngle, this.endAngle);

//   @override
//   void paint(Canvas canvas, Size size) {
//     double radius = size.width / 2;
//     Offset center = Offset(size.width / 2, size.height / 2);

//     Paint circlePaint = Paint()
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 4
//       ..color = const Color.fromARGB(46, 0, 0, 0);

//     // Paint activePaint = Paint()
//     //   ..style = PaintingStyle.stroke
//     //   ..strokeWidth = 8
//     //   ..color = Colors.blue;

//     Paint handlePaint = Paint()
//       ..style = PaintingStyle.stroke // Thay đổi từ fill sang stroke
//       ..strokeWidth = 3.0 // Độ dày của đường viền, tùy chỉnh theo ý muốn
//       ..color = Colors.white;

//     Paint handlePaint2 = Paint()
//       ..style = PaintingStyle.fill
//       ..color = Colors.white;

//     // Vẽ vòng tròn tĩnh
//     canvas.drawCircle(center, radius, circlePaint);

//     // // Vẽ phần đã chọn
//     // canvas.drawArc(Rect.fromCircle(center: center, radius: radius), startAngle,
//     //     endAngle - startAngle, false, activePaint);

//     // Tính toán vị trí của các handle (điểm bắt đầu và kết thúc)
//     Offset startHandle = Offset(
//       center.dx + radius * cos(startAngle),
//       center.dy + radius * sin(startAngle),
//     );

//     Offset endHandle = Offset(
//       center.dx + radius * cos(endAngle),
//       center.dy + radius * sin(endAngle),
//     );

//     // Vẽ hai điểm trượt
//     canvas.drawCircle(startHandle, 15, handlePaint);
//     canvas.drawCircle(endHandle, 10, handlePaint2);
//   }

//   @override
//   bool shouldRepaint(CircularSliderPainter oldDelegate) {
//     return oldDelegate.startAngle != startAngle ||
//         oldDelegate.endAngle != endAngle;
//   }
// }

// class InfiniteTimePicker extends StatefulWidget {
//   const InfiniteTimePicker({super.key});

//   @override
//   _InfiniteTimePickerState createState() => _InfiniteTimePickerState();
// }

// class _InfiniteTimePickerState extends State<InfiniteTimePicker> {
//   final int _initialHour =
//       24 * 100; // Bắt đầu từ giữa danh sách giờ (giả lập vô hạn)
//   final int _initialMinute =
//       60 * 100; // Bắt đầu từ giữa danh sách phút (giả lập vô hạn)

//   FixedExtentScrollController? _hourController;
//   FixedExtentScrollController? _minuteController;

//   int selectedHour = 0;
//   int selectedMinute = 0;

//   @override
//   void initState() {
//     super.initState();
//     _hourController = FixedExtentScrollController(initialItem: _initialHour)
//       ..addListener(
//         () {
//           print("OK");
//         },
//       );
//     _minuteController =
//         FixedExtentScrollController(initialItem: _initialMinute);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 60),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Bộ chọn giờ
//               Expanded(
//                 child: Container(
//                   //color: Colors.blue,
//                   height: 100,
//                   child: Stack(
//                     children: [
//                       ListWheelScrollView.useDelegate(
//                         controller: _hourController,
//                         itemExtent: 40.0,
//                         physics: const FixedExtentScrollPhysics(),
//                         onSelectedItemChanged: (int index) {
//                           setState(() {
//                             selectedHour = index % 24; // Giới hạn từ 0 đến 23
//                           });
//                         },
//                         childDelegate: ListWheelChildBuilderDelegate(
//                           builder: (context, index) {
//                             final displayHour = index % 24;
//                             return Center(
//                               child: Text(
//                                 displayHour.toString().padLeft(2, '0'),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "Second",
//                                     fontSize: 24,
//                                     color: selectedHour == index % 24
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.25)),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       //_buildFadingEffect(),
//                     ],
//                   ),
//                 ),
//               ),
//               const Text(
//                 ":",
//                 style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: "Second",
//                     color: Colors.white),
//               ),
//               // Bộ chọn phút
//               Expanded(
//                 child: Container(
//                   height: 100,
//                   child: Stack(
//                     children: [
//                       ListWheelScrollView.useDelegate(
//                         controller: _minuteController,
//                         itemExtent: 40.0,
//                         physics: const FixedExtentScrollPhysics(),
//                         onSelectedItemChanged: (int index) {
//                           setState(() {
//                             selectedMinute = index % 60; // Giới hạn từ 0 đến 59
//                           });
//                         },
//                         childDelegate: ListWheelChildBuilderDelegate(
//                           builder: (context, index) {
//                             final displayMinute = index % 60;
//                             return Center(
//                               child: Text(
//                                 displayMinute.toString().padLeft(2, '0'),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontFamily: "Second",
//                                     fontSize: 24,
//                                     color: selectedMinute == index % 60
//                                         ? Colors.white
//                                         : Colors.white.withOpacity(0.25)),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//                       //_buildFadingEffect(),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _hourController?.dispose();
//     _minuteController?.dispose();
//     super.dispose();
//   }
// }
