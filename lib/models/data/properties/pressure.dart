import 'package:vortex/models/providers/provider_data.dart';

import 'property.dart';
import 'property_unit.dart';
import 'dart:math';

class Pressure extends Property {
  bool isGauge = true;
  @override
  Stream<double>? get valueStream => 
          Stream.periodic(Duration(seconds: updateInterval), (_) => getValue())
                .asyncMap((v) async => await v)
                .asBroadcastStream();

  Pressure(super.provider, super.source, super.name) {
    unit = PropertyUnit.bar; // change based on settings
  }

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.kPa:
        return value * pow(10, 3);
      case PropertyUnit.psi:
        return value * 14.50377;
      case PropertyUnit.bar:
      default:
        return value;
    }
  }

  @override
  void convertUnit(PropertyUnit to) {
    switch (to) {
      case PropertyUnit.kPa:
        value = _getStandardVal() * pow(10, 3);
        unit = PropertyUnit.kPa;
        break;
      case PropertyUnit.psi:
        value = _getStandardVal()  * 14.50377;
        unit = PropertyUnit.psi;
        break;
      case PropertyUnit.bar:
      default:
        value = _getStandardVal();
        unit = PropertyUnit.bar;
        break;
    }
  }

  @override
  Future<double> getValue() async {
    value = double.parse(await provider.getValue(ProviderData.temperature, source) as String);
    return value;
  }

  @override
  String toString() {

    final strUnit = switch (unit) {
      PropertyUnit.kPa => "kPa",
      PropertyUnit.psi => "psi",
      PropertyUnit.bar => "bar",
      _ => " "
    };

    return "$value $strUnit";
  }
}
