import 'dart:async';
import 'package:vortex/models/data/chart/chart_point.dart';
import 'package:vortex/models/data/properties/property.dart';

enum ChartDirection { left, right, top, bottom }

abstract class ChartData {
  final String title;
  int updateInterval;

  double baseValue;
  double maxValue;
  double minValue;

  Stream<ChartPoint>? point;
  List<Property> sources;

  ChartData(this.title, this.sources, this.maxValue,
    {this.updateInterval = 1, this.baseValue = 0, this.minValue = 0});

  Future<ChartPoint> updatePoint();
  bool isValueVisibleOnAxis(ChartDirection dir, double val);
  String formatVisibleValue(ChartDirection dir, double val);
  String getAxisName(ChartDirection dir);
}
