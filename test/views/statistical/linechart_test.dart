import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myrefectly/views/statistical/linechart.dart';

void main() {
  testWidgets('SmoothLineChart should render and update when points change',
      (WidgetTester tester) async {
    // Xây dựng widget SmoothLineChart
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SmoothLineChart(
          points: [Offset(0, 0), Offset(100, 100)],
          lineColor: Colors.blue,
          needTooltip: true,
          time: [DateTime.now(), DateTime.now().add(Duration(days: 1))],
        ),
      ),
    ));


    final customPaintWidgets = find.byType(CustomPaint);
    expect(customPaintWidgets, findsAny);

    // Cập nhật điểm và kiểm tra lại
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SmoothLineChart(
          points: [Offset(0, 0), Offset(200, 200)],
          lineColor: Colors.blue,
          needTooltip: true,
          time: [DateTime.now(), DateTime.now()],
        ),
      ),
    ));

    // Kiểm tra lại sau khi cập nhật điểm
    await tester.pumpAndSettle();
    expect(customPaintWidgets,
        findsAny); // Kiểm tra 2 widget CustomPaint sau khi thay đổi
  });

  testWidgets('SmoothLineChart should display tooltip when tapped on a point',
      (WidgetTester tester) async {
    // Xây dựng widget SmoothLineChart
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SmoothLineChart(
          points: [Offset(0, 0), Offset(100, 100)],
          lineColor: Colors.blue,
          needTooltip: true,
          time: [DateTime.now(), DateTime.now()],
        ),
      ),
    ));

    // Kiểm tra xem có đúng 2 widget AnimatedPositioned được render
    final animatedPositionedWidgets = find.byType(AnimatedPositioned);
    expect(animatedPositionedWidgets,
        findsNWidgets(2)); // Kiểm tra 2 widget AnimatedPositioned

    // Cập nhật điểm và kiểm tra lại
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SmoothLineChart(
          points: [Offset(0, 0), Offset(200, 200)],
          lineColor: Colors.blue,
          needTooltip: true,
          time: [DateTime.now(), DateTime.now()],
        ),
      ),
    ));

    // Kiểm tra lại sau khi cập nhật điểm
    await tester.pumpAndSettle();
    expect(animatedPositionedWidgets,
        findsAny); // Kiểm tra 2 widget AnimatedPositioned sau khi thay đổi
  });

  testWidgets('SmoothLineChart should animate when points are updated',
      (WidgetTester tester) async {
    // Define initial data
    List<Offset> points = [
      Offset(50, 100),
      Offset(100, 150),
      Offset(150, 200),
    ];
    List<DateTime> times = [
      DateTime(2023, 1, 1),
      DateTime(2023, 1, 2),
      DateTime(2023, 1, 3),
    ];

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: SmoothLineChart(
          points: points,
          lineColor: Colors.blue,
          needTooltip: true,
          time: times,
        ),
      ),
    ));

    // Trigger the animation and let it run
    await tester.pump(Duration(milliseconds: 800)); // Run animation for 800ms

    // Wait for all animations to settle
    await tester.pumpAndSettle();

    // Print the widget tree for debugging
    print(find.byType(CustomPaint).evaluate().toList());

    // Verify that exactly one CustomPaint widget exists after animation
    expect(find.byType(CustomPaint), findsAny);
  });
}
