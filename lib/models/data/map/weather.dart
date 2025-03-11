import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/properties/pressure.dart';
import 'package:vortex/models/data/properties/temperature.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/models/providers/provider.dart';

class Weather {
  Pressure? pressure;
  Temperature? temperature;
  Speed? windSpeed;
  Provider weatherProvider;
  bool daily;

  final MapLocation location;

  Weather(this.weatherProvider, this.location, this.daily);

  Future<void> updateInfo() async {
    if (await location.getLocationInfo()) {
      if (pressure == null || temperature == null || windSpeed == null) {
        final data = [location.coordinates.toString()];
        if (daily) {
          data.add("daily");
        }

        pressure = Pressure(weatherProvider, data, "Atm Pressure");
        temperature = Temperature(weatherProvider, data, "Atm Temperature");
        windSpeed = Speed(weatherProvider, data, "Wind Speed");
      }
      await pressure!.getValue();
      await temperature!.getValue();
      await windSpeed!.getValue();
    }
  }
}
