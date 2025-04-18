import 'package:vortex/models/data/properties/property.dart';
import 'package:vortex/models/data/properties/property_unit.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'package:vortex/models/providers/weather_provider.dart';

class Length extends Property {
  Length(super.provider, super.source, super.name,
    {super.type = ProviderData.length, super.unit = PropertyUnit.m});

  double _getStandardVal() {
    switch (unit) {
      case PropertyUnit.ft:
        return value * 0.3048;
      case PropertyUnit.m:
      default:
        return value;
    }
  }

  @override
  void setUnit(PropertyUnit to) {
    switch (to) {
      case PropertyUnit.ft:
        value = _getStandardVal() / 0.3048;
        unit = PropertyUnit.ft;
        break;
      case PropertyUnit.m:
      default:
        value = _getStandardVal();
        unit = PropertyUnit.m;
        break;
    }
  }

    @override
  Future<double> getValue() async {
    value = double.parse(await provider.getValue(type, source) as String);
    value = double.parse(value.toStringAsFixed(2));

    setUnit(unit);
    return value;
  }

  @override
  String toString() {
    final strUnit = switch (unit) {
      PropertyUnit.ft => "ft",
      PropertyUnit.m => "m",
      _ => " "
    };

    return "$value $strUnit";
  }
}
