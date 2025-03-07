import 'dart:async';
import 'package:vortex/models/providers/provider_data.dart';
import 'property.dart';
import 'property_unit.dart';

class Power extends Property {
  DateTime _lastRecord = DateTime.now();
  final List<double> _recordedValues = [];
  double avgDailyPower = 0;
  bool displayAvg;

  @override
  Stream<double>? get valueStream =>
      Stream.periodic(Duration(seconds: updateInterval), (_) => getValue())
          .asyncMap((v) async {
        _recordValue(interval: updateInterval);
        return await v;
      }).asBroadcastStream();

  Power(super.provider, super.source, super.name,
      {super.unit = PropertyUnit.kWatt, this.displayAvg = true});

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.hp:
        return value / 1.341;
      case PropertyUnit.kWatt:
      default:
        return value;
    }
  }

  void _recordValue({int interval = 3600}) {
    if (DateTime.now().day - _lastRecord.day >= 1) {
      _recordedValues.clear();
      avgDailyPower = 0;
    }
    if ((_recordedValues.isEmpty ||
        (DateTime.now().millisecondsSinceEpoch - _lastRecord.millisecondsSinceEpoch) * 0.001 >= (interval))
      && value != 0) {
        _lastRecord = DateTime.now();
        _recordedValues.add(value);
        avgDailyPower =
            _recordedValues.reduce((a, b) => a + b) / _recordedValues.length;
    }
  }

  @override
  void convertUnit(PropertyUnit to) {
    switch (to) {
      case PropertyUnit.hp:
        value = _getStandardVal() * 1.341;
        unit = PropertyUnit.hp;
        break;
      case PropertyUnit.kWatt:
      default:
        value = _getStandardVal();
        unit = PropertyUnit.kWatt;
        break;
    }
  }

  @override
  Future<double> getValue() async {
    value = double.parse(
        await provider.getValue(ProviderData.power, source) as String);
    value = double.parse(value.toStringAsFixed(2));

    convertUnit(unit);
    return value;
  }

  @override
  String toString() {
    final strUnit = switch (unit) {
      PropertyUnit.hp => "HP",
      PropertyUnit.kWatt => "kW",
      _ => " "
    };

    return displayAvg ? "$avgDailyPower $strUnit" : "$value $strUnit";
  }
}
