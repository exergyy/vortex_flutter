import 'dart:async';

import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/models/data/chart/chart_point.dart';
import 'package:vortex/models/data/properties/power.dart';
import 'package:vortex/models/providers/provider_data.dart';

class PowerChart extends ChartData {
  double _currentX = 0;
  double _currentY = 0;
  Power? _power;

  @override
  Stream<ChartPoint>? get pointStream =>
      Stream.periodic(Duration(seconds: updateInterval), (_) => updatePoint())
            .asyncMap((x) async => await x);

  PowerChart(super.title, super.sources, super.maxValue) {
    for (var s in sources) {
      if (s.type == ProviderData.power) {
        _power = s as Power;
      }
    }

    if (_power == null) {
      throw TypeError();
    }

    // updateInterval = 240;
    updateInterval = 1;
    pointStream!.listen((p) {
        points.add(p);
        pointsController.sink.add(points);
    });
  }

  @override
  Future<ChartPoint> updatePoint() async {
    return ChartPoint(await _updateX(), await _updateY());
  }

  @override
  String getAxisName(ChartDirection dir) {
    switch (dir) {
      case ChartDirection.left:
        return "Power (${_power?.unit.toString().split(".")[1]})";
      case ChartDirection.bottom:
        return "Time (Hr)";
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
          return (val / 3600).toStringAsFixed(0);
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
        if (val <= 100 && val >= 0 && val % 1 == 0) {
          return true;
        }
        break;
      case ChartDirection.bottom:
        if (val <= (24 * 3600) && val >= 0 && (val / 3600) % 1 == 0) {
          return true;
        }
        break;
      default:
        return false;
    }
    return false;
  }

  Future<double> _updateY() async {
    _currentY = await _power?.getValue() ?? 0;
    return _currentY;
  }

  Future<double> _updateX() {
    _currentX += updateInterval;
    return Future.value(_currentX);
  }
}
