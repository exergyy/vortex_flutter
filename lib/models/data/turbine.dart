import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/data/properties/property.dart';
import 'package:vortex/models/data/controls/control.dart';

enum TurbineType { darrieus, savonius, hybrid }

class Turbine {
  final TurbineType type;

  double speed = 0;
  double cp = 0.4;
  double aspectRatio = 1.1;
  double mechEff = 0.8;
  double height = 0;
  double diameter = 0;

  Weather? operatingConditions;
  List<Property>? esp32Readings;
  List<Control>? controls;
  List<ChartData>? charts;

  Turbine(this.type);
}
