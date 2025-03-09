import 'dart:async';
import 'package:vortex/models/data/chart/chart_point.dart';
import 'package:vortex/models/data/properties/property.dart';

enum ChartDirection { left, right, top, bottom }

abstract class ChartData {
  final String title;
  int updateInterval;
  Stream<ChartPoint>? point;
  List<Property> sources;

  ChartData(this.title, this.sources, {this.updateInterval = 1});

  Future<ChartPoint> updatePoint();
  bool isValueVisibleOnAxis(ChartDirection dir, double val);
  String formatVisibleValue(ChartDirection dir, double val);
  String getAxisName(ChartDirection dir);
}
