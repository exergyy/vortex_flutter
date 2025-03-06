import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/data/properties/property.dart';
import 'package:vortex/models/data/controls/control.dart';

enum TurbineType { darrieus, savonius, hybrid }

class Turbine {
  final TurbineType type;
  double speed = 0;
  Weather? operatingConditions;
  List<Property>? esp32Readings;
  List<Control>? controls;
  List<ChartData>? charts;

  Turbine(this.type);
}
