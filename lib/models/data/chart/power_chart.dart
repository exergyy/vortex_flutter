import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/models/data/chart/chart_point.dart';
import 'package:vortex/models/data/properties/power.dart';
import 'package:vortex/models/data/properties/property.dart';

class PowerChart extends ChartData {
  double _currentX = 0;
  double _currentY = 0;

  @override
  Stream<ChartPoint>? get point =>
      Stream.periodic(Duration(seconds: updateInterval), (_) => updatePoint())
          .asyncMap((x) async => await x);

  PowerChart(super.title, super.sources, {super.updateInterval});

  @override
  Future<ChartPoint> updatePoint() async {
    return ChartPoint(await _updateX(), await _updateY());
  }

  @override
  String getAxisName(ChartDirection dir) {
    switch (dir) {
      case ChartDirection.left:
        for (Property s in sources) {
          if (s is Power) {
            return "Power (${s.unit.toString().split(".")[1]})";
          }
        }
        break;
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
          return val.toString();
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

  int _getInterval() {
    for (Property s in sources) {
      if (s is Power) {
        return s.updateInterval;
      }
    }
    throw TypeError();
  }

  Future<double> _updateY() async {
    for (Property s in sources) {
      if (s is Power) {
        _currentY = await s.getValue();
        return _currentY;
      }
    }
    throw TypeError();
  }

  Future<double> _updateX() {
    _currentX += updateInterval;
    return Future.value(_currentX);
  }
}
