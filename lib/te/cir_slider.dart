// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

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
//           child: DoubleCircularSlider(),
//         ),
//       ),
//     );
//   }
// }

// class TimePickerNotifier extends ChangeNotifier {
//   DateTime _time = DateTime.now();

//   DateTime get time => _time;

//   void performAction() {
//     // Thay đổi trạng thái và thông báo cho các widget lắng nghe
//     //_message = all_color[theme_selected];
//     notifyListeners();
//   }
// }

// class DoubleCircularSlider extends StatefulWidget {
//   @override
//   _DoubleCircularSliderState createState() => _DoubleCircularSliderState();
// }

// class _DoubleCircularSliderState extends State<DoubleCircularSlider> {
//   double startAngle = 0.0; // Góc bắt đầu
//   double endAngle = pi / 2; // Góc kết thúc
//   double minValue = 0;
//   double maxValue = 100;
//   double currentStartValue = 0;
//   double currentEndValue = 25;
//   bool point1 = false;
//   bool point2 = false;
//   int point = -1;

//   // Hàm chuyển đổi góc thành giá trị
//   double _angleToValue(double angle) {
//     double percentage = (angle / (2 * pi)) % 1;
//     return (percentage * (maxValue - minValue)) + minValue;
//   }

//   // Hàm xử lý khi kéo trượt
//   void _onPanUpdate(DragUpdateDetails details) {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     Offset center = Offset(150, 150);
//     Offset position = details.localPosition - center;

//     double angle = atan2(position.dy, position.dx);

//     // Đảm bảo góc dương
//     if (angle < 0) angle += 2 * pi;

//     setState(() {
//       if (point == 1) {
//         startAngle = angle;
//         currentStartValue = _angleToValue(startAngle);
//         Provider.of<TimePickerNotifier>(context, listen: false)._time =
//             DateTime.now();
//         Provider.of<TimePickerNotifier>(context, listen: false).performAction();
//       } else if (point == 2) {
//         endAngle = angle;
//         currentEndValue = _angleToValue(endAngle);
//       }
//     });
//   }

//   void _onPanEnd(DragEndDetails details) {
//     point = -1;
//   }

//   double roundDouble(double value, int places) {
//     double mod = pow(10.0, places).toDouble();
//     return ((value * mod).round().toDouble() / mod);
//   }

//   void _onPanStart(DragStartDetails details) {
//     RenderBox renderBox = context.findRenderObject() as RenderBox;
//     Offset center = Offset(150, 150);
//     //renderBox.size.center(Offset.zero);
//     Offset position = details.localPosition - center;

//     double angle = atan2(position.dy, position.dx);
//     // Đảm bảo góc dương
//     if (angle < 0) angle += 2 * pi;
//     double a = roundDouble(angle, 1);
//     double b = roundDouble(endAngle, 1);

//     if ((roundDouble(angle, 1) >= roundDouble(endAngle, 1) - 0.2 &&
//         roundDouble(angle, 1) <= roundDouble(endAngle, 1) + 0.2)) {
//       point = 2;
//     } else if (roundDouble(angle, 1) >= roundDouble(startAngle, 1) - 0.2 &&
//         roundDouble(angle, 1) <= roundDouble(startAngle, 1) + 0.2) {
//       point = 1;
//     }

//     return;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Consumer<TimePickerNotifier>(
//           builder: (context, value, child) {
//             return GestureDetector(
//               onPanUpdate: _onPanUpdate,
//               onPanEnd: _onPanEnd,
//               onPanStart: _onPanStart,
//               child: CustomPaint(
//                 size: Size(300, 300),
//                 painter: CircularSliderPainter(startAngle, endAngle),
//               ),
//             );
//           },
//         ),
//         ClipOval(
//           child: Container(
//               width: 265,
//               height: 265,
//               color: Colors.transparent,
//               child: InfiniteTimePicker()),
//         ),
//       ],
//     );
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
//     return Consumer<TimePickerNotifier>(
//       builder: (context, value, child) {
//         return Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 60),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Bộ chọn giờ
//                   Expanded(
//                     child: Container(
//                       //color: Colors.blue,
//                       height: 100,
//                       child: Stack(
//                         children: [
//                           ListWheelScrollView.useDelegate(
//                             controller: _hourController,
//                             itemExtent: 40.0,
//                             physics: const FixedExtentScrollPhysics(),
//                             onSelectedItemChanged: (int index) {
//                               setState(() {
//                                 selectedHour =
//                                     index % 24; // Giới hạn từ 0 đến 23
//                               });
//                             },
//                             childDelegate: ListWheelChildBuilderDelegate(
//                               builder: (context, index) {
//                                 final displayHour = index % 24;
//                                 return Center(
//                                   child: Text(
//                                     displayHour.toString().padLeft(2, '0'),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: "Second",
//                                         fontSize: 24,
//                                         color: selectedHour == index % 24
//                                             ? Colors.white
//                                             : Colors.white.withOpacity(0.25)),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           //_buildFadingEffect(),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const Text(
//                     ":",
//                     style: TextStyle(
//                         fontSize: 24,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: "Second",
//                         color: Colors.white),
//                   ),
//                   // Bộ chọn phút
//                   Expanded(
//                     child: Container(
//                       height: 100,
//                       child: Stack(
//                         children: [
//                           ListWheelScrollView.useDelegate(
//                             controller: _minuteController,
//                             itemExtent: 40.0,
//                             physics: const FixedExtentScrollPhysics(),
//                             onSelectedItemChanged: (int index) {
//                               setState(() {
//                                 selectedMinute =
//                                     index % 60; // Giới hạn từ 0 đến 59
//                               });
//                             },
//                             childDelegate: ListWheelChildBuilderDelegate(
//                               builder: (context, index) {
//                                 final displayMinute = index % 60;
//                                 return Center(
//                                   child: Text(
//                                     displayMinute.toString().padLeft(2, '0'),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: "Second",
//                                         fontSize: 24,
//                                         color: selectedMinute == index % 60
//                                             ? Colors.white
//                                             : Colors.white.withOpacity(0.25)),
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                           //_buildFadingEffect(),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   @override
//   void dispose() {
//     _hourController?.dispose();
//     _minuteController?.dispose();
//     super.dispose();
//   }
// }
