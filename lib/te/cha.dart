import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {
  List<Color> gradientColors = [
    Colors.white,
    Colors.white,
  ];

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.70,
      child: Padding(
        padding: const EdgeInsets.only(
          right: 18,
          left: 12,
          top: 24,
          bottom: 12,
        ),
        child: LineChart(
          mainData(),
          duration: Duration(milliseconds: 500),
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    var style = TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 13,
        color: Colors.black.withOpacity(0.3));
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = Text('M', style: style);
        break;
      case 2:
        text = Text('T', style: style);
        break;
      case 4:
        text = Text('W', style: style);
        break;
      case 6:
        text = Text('T', style: style);
        break;
      case 8:
        text = Text('F', style: style);
        break;
      case 10:
        text = Text('S', style: style);
        break;
      case 12:
        text = Text('S', style: style);
        break;
      default:
        text = Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          show: true,
          color: Colors.black.withOpacity(0.25),
          spots: const [
            FlSpot(0, 5),
            FlSpot(2, 1),
            FlSpot(4, 2),
            FlSpot(6, 5.1),
            FlSpot(8, 3),
            FlSpot(10, 1),
            FlSpot(12, 2),
          ],
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(0, 6),
            FlSpot(2, 2),
            FlSpot(4, 3),
            FlSpot(6, 3.1),
            FlSpot(8, 1),
            FlSpot(10, 6),
            FlSpot(12, 4),
          ],
          shadow:
              Shadow(color: Colors.black.withOpacity(0.25), blurRadius: 2.5),
          isCurved: true,
          color: Colors.white,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
        ),
      ],
      lineTouchData: LineTouchData(
          enabled: true,
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (touchedSpot) => Colors.white,
            getTooltipItems: (touchedSpots) =>
                [LineTooltipItem("asdsdds", TextStyle(color: Colors.white))],
          )),
    );
  }
}
