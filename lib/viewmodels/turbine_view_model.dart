import 'package:vortex/models/data/controls/control.dart';
import 'package:vortex/models/data/controls/toggle_control.dart';
import 'package:vortex/models/data/controls/variable_control.dart';
import 'package:vortex/models/data/properties/property.dart';
import 'package:vortex/models/data/properties/property_unit.dart';
import 'package:vortex/models/data/properties/wind_speed.dart';
import 'package:vortex/models/providers/provider.dart';

import '../models/data/properties/pressure.dart';
import '../models/data/properties/temperature.dart';
import '../models/providers/dummy_provider.dart';

class TurbineViewModel {
  final title = "Turbine Status";
  List<Property>? esp32Readings;
  final Provider esp32Provider = DummyProvider();

  List<Control>? controls;

  TurbineViewModel() {
    esp32Readings = [
      Temperature(esp32Provider, ["40", "60"], "Bearing Temp"),
      Temperature(esp32Provider, ["40", "45"], "Atm Temp"),
      WindSpeed(esp32Provider, ["5", "12"], "Wind Speed"),
      Pressure(esp32Provider, ["1", "2"], "Atm Pressure"),
      Temperature(esp32Provider, ["45", "50"], "Motor Temp"),
      WindSpeed(esp32Provider, ["2", "6"], "Motor Speed", unit: PropertyUnit.mS),
    ];

    controls = [
      ToggleControl(esp32Provider, ["motor_breaks"], "Motor Brakes"),
      VariableControl(esp32Provider, ["pitch"], "Pitch Angle", -2, 2, 0.1),
//     (ControlType.Value, Icons.rotate_left_rounded, "Pitch Angle", 0),
//     (ControlType.Options, Icons.speed, "Motor Speed", (["High", "Low"], [true, false]))
    ];
  }

  Future<List<Property>> getInfo() async {
    for (var r in esp32Readings!) {
      await r.getValue();
    }
    return esp32Readings!;
  }

  Future<List<Control>> getControls() async {
    for (var c in controls!) {
      await c.getValue();
    }
    return controls!;
  }

}
