import 'package:vortex/models/data/chart/power_chart.dart';
import 'package:vortex/models/data/controls/toggle_control.dart';
import 'package:vortex/models/data/controls/variable_control.dart';
import 'package:vortex/models/data/properties/pressure.dart';
import 'package:vortex/models/data/properties/property_unit.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/models/data/properties/temperature.dart';
import 'package:vortex/models/data/turbine.dart';
import 'package:vortex/models/providers/dummy_provider.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/data/properties/power.dart';

class TurbineViewModel {
  final title = "Turbine Status";
  final Provider esp32Provider = DummyProvider();
  final Turbine turbine = Turbine(TurbineType.hybrid);

  TurbineViewModel() {
    turbine.esp32Readings = [
      Temperature(esp32Provider, ["40", "60"], "Bearing Temp"),
      Temperature(esp32Provider, ["40", "45"], "Atm Temp"),
      Speed(esp32Provider, ["5", "12"], "Wind Speed"),
      Pressure(esp32Provider, ["1", "2"], "Atm Pressure"),
      Temperature(esp32Provider, ["45", "50"], "Motor Temp"),
      Speed(esp32Provider, ["2", "6"], "Motor Speed",
        unit: PropertyUnit.RPM),
    ];

    turbine.controls = [
      ToggleControl(esp32Provider, ["motor_breaks"], "Motor Brakes"),
      VariableControl(esp32Provider, ["pitch"], "Pitch Angle", -2, 2, 0.1),
      //TODO:
      //     (ControlType.Value, Icons.rotate_left_rounded, "Pitch Angle", 0),
      //     (ControlType.Options, Icons.speed, "Motor Speed", (["High", "Low"], [true, false]))
    ];

    turbine.charts = [
      PowerChart("Power", [Power(esp32Provider, ["4", "5"], "Power")]),
      PowerChart("Power", [Power(esp32Provider, ["4", "5"], "Power")]),
    ];
  }
}
