import 'dart:math';
import 'package:flutter/material.dart';

class TimeSetter extends StatefulWidget {
  DateTime time;
  final ValueChanged<DateTime> onTimeChanged; // Callback

  TimeSetter({required this.time, required this.onTimeChanged});

  @override
  _TimeSetterState createState() => _TimeSetterState();
}

class _TimeSetterState extends State<TimeSetter> {
  double startAngle = 0; // Góc bắt đầu
  double endAngle = 0; // Góc kết thúc
  double screenWidth = 1;
  double screenHeight = 1;

  FixedExtentScrollController? _hourController;
  FixedExtentScrollController? _minuteController;

  int selectedHour = 0;
  int selectedMinute = 0;

  @override
  void initState() {
    super.initState();
    selectedHour = widget.time.hour;
    selectedMinute = widget.time.minute;

    _hourController = FixedExtentScrollController(initialItem: selectedHour);
    _minuteController =
        FixedExtentScrollController(initialItem: selectedMinute);

    // Tính toán góc ban đầu
    startAngle = pi * 2 * (selectedMinute) / 60 - pi / 2;
    endAngle = pi * 2 * (selectedHour) / 12 - pi / 2;

    // Gọi hàm sau khi build hoàn tất
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        // Cập nhật lại để đảm bảo đúng vị trí ban đầu
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          size: Size(screenWidth * 0.6, screenWidth * 0.6),
          painter: CircularSliderPainter(startAngle, endAngle),
        ),
        ClipOval(
          child: Container(
              width: screenWidth * 0.65,
              height: screenWidth * 0.65,
              color: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Bộ chọn giờ
                        Expanded(
                          child: Container(
                            height: screenWidth * 0.3,
                            child: Stack(
                              children: [
                                ListWheelScrollView.useDelegate(
                                  controller: _hourController,
                                  itemExtent: screenWidth * 0.1,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedHour =
                                          index % 24; // Giới hạn từ 0 đến 23
                                      endAngle =
                                          pi * 2 * selectedHour / 12 - pi / 2;

                                      // Cập nhật biến time khi chọn giờ mới
                                      widget.time = DateTime(
                                        widget.time.year,
                                        widget.time.month,
                                        widget.time.day,
                                        selectedHour,
                                        selectedMinute,
                                      );
                                      widget.onTimeChanged(
                                          widget.time); // Gọi callback
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      final displayHour = index % 24;
                                      return Center(
                                        child: Text(
                                          displayHour
                                              .toString()
                                              .padLeft(2, '0'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Second",
                                              fontSize: screenWidth * 0.08,
                                              color: selectedHour == displayHour
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.25)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          ":",
                          style: TextStyle(
                              fontSize: screenWidth * 0.08,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Second",
                              color: Colors.white),
                        ),
                        // Bộ chọn phút
                        Expanded(
                          child: Container(
                            height: screenWidth * 0.3,
                            child: Stack(
                              children: [
                                ListWheelScrollView.useDelegate(
                                  controller: _minuteController,
                                  itemExtent: screenWidth * 0.1,
                                  physics: const FixedExtentScrollPhysics(),
                                  onSelectedItemChanged: (int index) {
                                    setState(() {
                                      selectedMinute =
                                          index % 60; // Giới hạn từ 0 đến 59
                                      startAngle =
                                          pi * 2 * (selectedMinute) / 60 -
                                              pi / 2;

                                      // Cập nhật biến time khi chọn phút mới
                                      widget.time = DateTime(
                                        widget.time.year,
                                        widget.time.month,
                                        widget.time.day,
                                        selectedHour,
                                        selectedMinute,
                                      );
                                      widget.onTimeChanged(
                                          widget.time); // Gọi callback
                                    });
                                  },
                                  childDelegate: ListWheelChildBuilderDelegate(
                                    builder: (context, index) {
                                      final displayMinute = index % 60;
                                      return Center(
                                        child: Text(
                                          displayMinute
                                              .toString()
                                              .padLeft(2, '0'),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: "Second",
                                              fontSize: screenWidth * 0.08,
                                              color: selectedMinute ==
                                                      displayMinute
                                                  ? Colors.white
                                                  : Colors.white
                                                      .withOpacity(0.25)),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _hourController?.dispose();
    _minuteController?.dispose();
    super.dispose();
  }
}

class CircularSliderPainter extends CustomPainter {
  final double startAngle;
  final double endAngle;

  CircularSliderPainter(this.startAngle, this.endAngle);

  @override
  void paint(Canvas canvas, Size size) {
    double radius = size.width / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..color = const Color.fromARGB(46, 0, 0, 0);

    Paint handlePaint = Paint()
      ..style = PaintingStyle.stroke // Thay đổi từ fill sang stroke
      ..strokeWidth = 3.0 // Độ dày của đường viền, tùy chỉnh theo ý muốn
      ..color = Colors.white;

    Paint handlePaint2 = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white;

    // Vẽ vòng tròn tĩnh
    canvas.drawCircle(center, radius, circlePaint);

    // Tính toán vị trí của các handle (điểm bắt đầu và kết thúc)
    Offset startHandle = Offset(
      center.dx + radius * cos(startAngle),
      center.dy + radius * sin(startAngle),
    );

    Offset endHandle = Offset(
      center.dx + radius * cos(endAngle),
      center.dy + radius * sin(endAngle),
    );

    // Vẽ hai điểm trượt
    canvas.drawCircle(startHandle, 15, handlePaint);
    canvas.drawCircle(endHandle, 10, handlePaint2);
  }

  @override
  bool shouldRepaint(CircularSliderPainter oldDelegate) {
    return oldDelegate.startAngle != startAngle ||
        oldDelegate.endAngle != endAngle;
  }
}
