import 'dart:async';
import 'package:vortex/models/data/chart/chart_point.dart';

import '../properties/property.dart';

abstract class ChartData {
  final String title;

  Stream<ChartPoint>? point;
  List<Property> sources;

  int updateInterval = 1;

  ChartData(this.title, this.sources);

  Future<ChartPoint> updatePoint();
}
