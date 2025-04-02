import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/models/data/chart/chart_point.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/models/data/properties/power.dart';
import 'package:vortex/models/data/turbine.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'dart:math';

class CpTsrChart extends ChartData {
  double _currentX = 0;
  double _currentY = 0;
  double _airVelocity = 0;

  Power? _producedPower;
  Speed? _windSpeed;
  Speed? _rotorSpeed;

  double turbineDiameter;
  double turbineHeight;

  @override
  Stream<ChartPoint>? get pointStream =>
    Stream.periodic(Duration(seconds: updateInterval), (_) => updatePoint())
          .asyncMap((x) async => await x);

  CpTsrChart(super.title, super.sources, super.maxValue, this.turbineDiameter, this.turbineHeight){
    for (var s in sources) {
      switch (s.type) {
        case ProviderData.power:
        _producedPower = s as Power;
        break;

        case ProviderData.windSpeed:
        _windSpeed = s as Speed;
        break;

        case ProviderData.speed:
        _rotorSpeed = s as Speed;
        break;

        default:
        continue;
      }
    }

    if (_producedPower == null || _windSpeed == null || _rotorSpeed == null) {
      throw TypeError();
    }

    updateInterval = 60;

    pointStream!.listen((p) {
        points.add(p);
        pointsController.sink.add(points);
    });
  }


  @override
  String getAxisName(ChartDirection dir) {
    switch (dir) {
      case ChartDirection.left:
        return "Cp";
      case ChartDirection.bottom:
        return "TSR";
      default:
        break;
    }
    return "";
  }

  @override
  String formatVisibleValue(ChartDirection dir, double val) {
    if (isValueVisibleOnAxis(dir, val)) {
      switch (dir) {
        case ChartDirection.left:
          return val.toStringAsFixed(0);
        case ChartDirection.bottom:
          return val.toStringAsFixed(0);
        default:
          break;
      }
    }
    return "";
  }

  @override
  bool isValueVisibleOnAxis(ChartDirection dir, double val) {
    switch (dir) {
      case ChartDirection.left:
        if (val <= 10 && val >= 0 && val % 1 == 0) {
          return true;
        }
        break;
      case ChartDirection.bottom:
        if (val <= 10 && val >= 0 && val % 1 == 0) {
          return true;
        }
        break;
      default:
        break;
    }
    return false;
  }

  @override
  Future<ChartPoint> updatePoint() async {
    return ChartPoint(await _updateX(), await _updateY());
  }

  Future<double> _updateY() async {
    _airVelocity = await _windSpeed?.getValue() ?? 0;

    final power = await _producedPower?.getValue() ?? 0;

    // handle area for hybrid, darius and savonious seprately
    final projectedArea = turbineHeight * turbineDiameter;

    // handle different air densities
    final density = 1.2;

    final theorticalPower =  0.5 * density * projectedArea * pow(_airVelocity, 3);

    if (theorticalPower == 0) {
      return 0;
    }

    _currentY = double.parse((power / theorticalPower).toStringAsFixed(2));
    return _currentY;
  }

  Future<double> _updateX() async {
   double tipVelocity = await _rotorSpeed?.getValue() ?? 0;
   tipVelocity = tipVelocity * (3.14 * turbineDiameter / 60);

   _currentX = double.parse((tipVelocity / _airVelocity).toStringAsFixed(2));
   return _currentX;
  }

}
