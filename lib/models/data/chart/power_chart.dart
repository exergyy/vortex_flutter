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

  PowerChart(super.title, super.sources) {
    updateInterval = _getInterval();
  }

  @override
  Future<ChartPoint> updatePoint() async {
    return ChartPoint(await _updateX(), await _updateY());
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
