import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/properties/pressure.dart';
import 'package:vortex/models/data/properties/temperature.dart';
import 'package:vortex/models/data/properties/wind_speed.dart';
import 'package:vortex/models/providers/provider.dart';

class Weather {
  Pressure? pressure;
  Temperature? temperature;
  WindSpeed? windSpeed;
  Provider weatherProvider;

  final MapLocation location;

  Weather(this.weatherProvider, this.location);

  Future<void> updateInfo() async {
    if (await location.getLocationInfo()) {
      if (pressure == null || temperature == null || windSpeed == null) {
        pressure = Pressure(weatherProvider, [location.coordinates.toString()], "Atm Pressure");
        temperature = Temperature(weatherProvider, [location.coordinates.toString()], "Atm Temperature");
        windSpeed = WindSpeed(weatherProvider, [location.coordinates.toString()], "Wind Speed");
      }
      await pressure!.getValue();
      await temperature!.getValue();
      await windSpeed!.getValue();
    }
  }
}
