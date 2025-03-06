import 'dart:async';
import 'package:vortex/models/providers/provider_data.dart';
import 'property.dart';
import 'property_unit.dart';

class Power extends Property {
  @override
  Stream<double>? get valueStream =>
  Stream.periodic(Duration(seconds: updateInterval), (_) => getValue())
  .asyncMap((v) async => await v)
  .asBroadcastStream();

  Power(super.provider, super.source, super.name,
    {super.unit = PropertyUnit.kWatt});

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.hp:
      return value / 1.341;
      case PropertyUnit.kWatt:
      default:
      return value;
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

    return "$value $strUnit";
  }
}
