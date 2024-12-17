import 'package:flutter/material.dart';

class MultiArcPainter extends CustomPainter {
  final Gradient gradient;
  final double strokeWidth;
  final double startAngle;

  final double spacing; // Khoảng cách giữa các vòng cung
  List<double> percent;
  MultiArcPainter({
    required this.percent,
    required this.gradient,
    this.strokeWidth = 5.0,
    this.startAngle = 0.0,
    this.spacing = 10.0, // Khoảng cách giữa các vòng cung
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < percent.length; i++) {
      final rect = Rect.fromLTWH(
        spacing * i, // Dịch chuyển vị trí theo spacing
        spacing * i, // Dịch chuyển vị trí theo spacing
        size.width - spacing * 2 * i,
        size.height - spacing * 2 * i,
      );

      final paint = Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        rect,
        startAngle,
        percent[i] * 3.14 * 2,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class MultiArcWidget extends StatelessWidget {
  final Gradient gradient;
  final double strokeWidth;
  final double startAngle;
  final double spacing;
  final double width;

  List<double> percent;

  MultiArcWidget(
      {required this.width,
      required this.gradient,
      this.strokeWidth = 5.0,
      this.startAngle = 0.0,
      this.spacing = 10.0,
      required this.percent});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width), // Kích thước của widget vòng cung
      painter: MultiArcPainter(
          gradient: gradient,
          strokeWidth: strokeWidth,
          startAngle: startAngle,
          spacing: spacing,
          percent: percent),
    );
  }
}
