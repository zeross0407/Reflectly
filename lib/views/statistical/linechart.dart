import 'package:flutter/material.dart';
import 'package:myrefectly/theme/color.dart';

class SmoothLineChart extends StatefulWidget {
  final List<Offset> points;
  final Color lineColor;
  final bool needTooltip;
  final List<DateTime> time;
  const SmoothLineChart({
    super.key,
    required this.points,
    required this.lineColor,
    required this.needTooltip,
    required this.time,
  });

  @override
  _SmoothLineChartState createState() => _SmoothLineChartState();
}

class _SmoothLineChartState extends State<SmoothLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Offset> _oldPoints;
  late List<Offset> _currentPoints;
  late Animation<double> _animation;

  int p = 1;

  @override
  void initState() {
    super.initState();
    _oldPoints = List.from(widget.points);
    _currentPoints = List.from(widget.points);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant SmoothLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.points.length != widget.points.length) {
      _oldPoints = List.from(_currentPoints);
      _currentPoints = List.from(widget.points);

      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Offset> _interpolatePoints() {
    List<Offset> interpolatedPoints = [];
    for (int i = 0; i < _currentPoints.length; i++) {
      final oldPoint =
          i < _oldPoints.length ? _oldPoints[i] : _currentPoints[i];
      final newPoint = _currentPoints[i];
      final dx = oldPoint.dx + (newPoint.dx - oldPoint.dx) * _animation.value;
      final dy = oldPoint.dy + (newPoint.dy - oldPoint.dy) * _animation.value;
      interpolatedPoints.add(Offset(dx, dy));
    }
    return interpolatedPoints;
  }

  String formatDate(DateTime dateTime) {
    String day = dateTime.day.toString().padLeft(2, '0');

    String month = [
      "JAN",
      "FEB",
      "MAR",
      "APR",
      "MAY",
      "JUN",
      "JUL",
      "AUG",
      "SEP",
      "OCT",
      "NOV",
      "DEC"
    ][dateTime.month - 1];

    String year = dateTime.year.toString().substring(2);

    return "$day $month, $year";
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;

    return GestureDetector(
      onTapDown: (details) {
        for (var i = 0; i < widget.points.length; i++) {
          if ((details.localPosition.dx - widget.points[i].dx).abs() <= 10 &&
              (details.localPosition.dy -
                          widget.points[i].dy -
                          screenWidth * 0.15)
                      .abs() <=
                  10) {
            setState(() {
              p = i;
            });
          }
        }
      },
      child: Container(
        height: screenWidth * 0.55,
        child: Stack(children: [
          Padding(
            padding: EdgeInsets.only(top: screenWidth * 0.15),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(double.infinity, 150),
                  painter: SmoothLineChartPainter(
                      _interpolatePoints(), widget.lineColor),
                );
              },
            ),
          ),
          if (widget.needTooltip && widget.points.isNotEmpty)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: widget.points[p].dy,
              left: widget.points[p].dx - (screenWidth * 0.16 / 2),
              child: Container(
                alignment: Alignment.center,
                width: screenWidth * 0.16,
                height: screenWidth * 0.11,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                    boxShadow: my_shadow),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${((1 - (widget.points[p].dy / (screenWidth * 0.55 * 0.65))) * 4 * (10 / 4)).toStringAsFixed(1)}",
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontFamily: "Second"),
                    ),
                    if (widget.time.length > 0)
                      Text(
                        "${formatDate(widget.time[p - 1])}",
                        style: TextStyle(
                            fontSize: screenWidth * 0.02,
                            fontWeight: FontWeight.w900,
                            color: Colors.black.withOpacity(0.5),
                            fontFamily: "Second"),
                      )
                  ],
                ),
              ),
            ),
          if (widget.needTooltip && widget.points.isNotEmpty)
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              top: widget.points[p].dy +
                  screenWidth * 0.15 -
                  (screenWidth * 0.04 / 2),
              left: widget.points[p].dx - (screenWidth * 0.04 / 2),
              child: Container(
                width: screenWidth * 0.04,
                height: screenWidth * 0.04,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
            ),
        ]),
      ),
    );
  }
}

class SmoothLineChartPainter extends CustomPainter {
  final List<Offset> points;
  final Color lineColor;

  SmoothLineChartPainter(this.points, this.lineColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.0125
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();

    if (points.length < 2) return;

    path.moveTo(points.first.dx, points.first.dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];

      Offset mid = Offset(p0.dx + (p1.dx - p0.dx) / 2, (p0.dy + p1.dy) / 2);

      path.quadraticBezierTo(
        p0.dx + (mid.dx - p0.dx) / 2,
        p0.dy,
        mid.dx,
        mid.dy,
      );

      path.quadraticBezierTo(
        mid.dx + (p1.dx - mid.dx) / 2,
        p1.dy,
        p1.dx,
        p1.dy,
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
