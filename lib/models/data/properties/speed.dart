import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vortex/models/data/properties/property.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'package:vortex/models/providers/weather_provider.dart';
import 'property_unit.dart';
import 'dart:math';

class Speed extends Property {
  double direction = 0;
  double diameter;

  @override
  Stream<double>? get valueStream =>
      Stream.periodic(Duration(seconds: updateInterval), (_) => getValue())
          .asyncMap((v) async => await v)
          .asBroadcastStream();

  Speed(super.provider, super.source, super.name,
    {super.type = ProviderData.windSpeed, super.unit = PropertyUnit.kmHr, this.diameter = 0});

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.mS:
        return value / (5 / 18);
      case PropertyUnit.ftS:
        return value / 1.097;
      case PropertyUnit.mpH:
        return value / 1.609;
      case PropertyUnit.RPM:
        return value / 8.8419;
      case PropertyUnit.kmHr:
      default:
        return value;
    }
  }

  @override
  void setUnit(PropertyUnit to) {
    switch (to) {
      case PropertyUnit.mS:
        value = _getStandardVal() * (5 / 18);
        unit = PropertyUnit.mS;
        break;
      case PropertyUnit.ftS:
        value = _getStandardVal() * 1.097;
        unit = PropertyUnit.ftS;
        break;
      case PropertyUnit.mpH:
        value = _getStandardVal() * 1.609;
        unit = PropertyUnit.mpH;
        break;
      case PropertyUnit.RPM:
        value = _getStandardVal() * (1000 / (3.14 * diameter * 60));
        unit = PropertyUnit.RPM;
      case PropertyUnit.kmHr:
      default:
        value = _getStandardVal();
        unit = PropertyUnit.kmHr;
        break;
    }
  }

  @override
  Future<double> getValue() async {
    var sourceUnit = unit;

    if (provider is WeatherProvider) {
      var res = await provider.getValue(type, source) as String;
      var splitRes = res.split(",");
      value = double.parse(splitRes[0]);
      direction = double.parse(splitRes[1]);
    } else {
      value = double.parse(await provider.getValue(type, source) as String);
      sourceUnit = PropertyUnit.kmHr;
    }

    if (sourceUnit != unit) {
      setUnit(unit);
    }

    value = double.parse(value.toStringAsFixed(2));

    return value;
  }

  @override
  String toString() {
    final strUnit = switch (unit) {
      PropertyUnit.mS => "m/s",
      PropertyUnit.ftS => "ft/s",
      PropertyUnit.mpH => "mph",
      PropertyUnit.kmHr => "km/hr",
      PropertyUnit.RPM => "RPM",
      _ => " "
    };

    return "$value $strUnit";
  }
}
