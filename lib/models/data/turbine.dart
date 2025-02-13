import 'package:vortex/models/data/map/weather.dart';

enum TurbineType {
  darrieus,
  savonius,
  hybrid
}

class Turbine {
  final TurbineType type;
  double speed = 0;
  Weather operatingConditions;

  Turbine(this.type, this.operatingConditions);
}