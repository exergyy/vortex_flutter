import 'package:fl_chart/fl_chart.dart';

class ChartPoint {
  final double x;
  final double y;

  ChartPoint(this.x, this.y);

  @override
  String toString() => "$x,$y";

  FlSpot toFlSpot() => FlSpot(x, y);
}
