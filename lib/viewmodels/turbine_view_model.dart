import 'package:vortex/models/data/chart/cp_TSR_chart.dart';
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
import 'package:vortex/models/providers/provider_data.dart';

class TurbineViewModel {
  final title = "Turbine Status";
  final Provider esp32Provider = DummyProvider();
  final Turbine turbine = Turbine(TurbineType.hybrid);

  TurbineViewModel() {
    turbine.height = 3;
    turbine.diameter = 2;
    final power = Power(esp32Provider, ["4", "5"], "Power");
    final windSpeed = Speed(esp32Provider, ["5", "12"], "Wind Speed");
    final rotorSpeed = Speed(esp32Provider, ["100", "200"], "Motor Speed", type: ProviderData.motorSpeed, unit: PropertyUnit.RPM, diameter: turbine.diameter);

    turbine.esp32Readings = [
      power,
      windSpeed,
      rotorSpeed,
      Temperature(esp32Provider, ["40", "45"], "Atm Temp"),
      Pressure(esp32Provider, ["1", "2"], "Atm Pressure"),
      Temperature(esp32Provider, ["45", "50"], "Motor Temp"),
    ];

    turbine.controls = [
      ToggleControl(esp32Provider, ["motor_breaks"], "Motor Brakes"),
      VariableControl(esp32Provider, ["pitch"], "Pitch Angle", -2, 2, 0.1),
      //TODO:
      //     (ControlType.Options, Icons.speed, "Motor Speed", (["High", "Low"], [true, false]))
    ];

    turbine.charts = [
      PowerChart("Power Output", [power], 5),
      CpTsrChart("Cp-TSR", [power, windSpeed, rotorSpeed], 10, turbine.diameter, turbine.height)
    ];
  }
}
