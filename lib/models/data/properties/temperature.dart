import 'dart:async';
import 'package:vortex/models/providers/provider_data.dart';
import 'property.dart';
import 'property_unit.dart';

class Temperature extends Property {
  @override
  Stream<double>? get valueStream =>
  Stream.periodic(Duration(seconds: updateInterval), (_) => getValue())
  .asyncMap((v) async => await v)
  .asBroadcastStream();

  Temperature(super.provider, super.source, super.name,
    {super.unit = PropertyUnit.kelvin});

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.celisus:
      return value - 273;
      case PropertyUnit.fahrenheit:
      return ((value - 32) * 5 / 9) + 273.15;
      case PropertyUnit.kelvin:
      default:
      return value;
    }
  }

  @override
  void convertUnit(PropertyUnit to) {
    switch (to) {
      case PropertyUnit.celisus:
      value = _getStandardVal() + 273.15;
      unit = PropertyUnit.celisus;
      break;
      case PropertyUnit.fahrenheit:
      value = ((_getStandardVal() - 273.15) * 9 / 5) + 32;
      unit = PropertyUnit.celisus;
      break;
      case PropertyUnit.kelvin:
      default:
      value = _getStandardVal();
      unit = PropertyUnit.kelvin;
      break;
    }
  }

  @override
  Future<double> getValue() async {
    value = double.parse(
      await provider.getValue(ProviderData.temperature, source) as String);

    convertUnit(unit);
    value = double.parse(value.toStringAsFixed(2));
    return value;
  }

  @override
  String toString() {
    final strUnit = switch (unit) {
      PropertyUnit.celisus => "°C",
      PropertyUnit.fahrenheit => "°F",
      PropertyUnit.kelvin => "K",
      _ => " "
    };

    return "$value $strUnit";
  }
}
