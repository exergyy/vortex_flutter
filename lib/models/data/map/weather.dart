import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/properties/length.dart';
import 'package:vortex/models/data/properties/pressure.dart';
import 'package:vortex/models/data/properties/temperature.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';

class Weather {
  Pressure? pressure;
  Temperature? temperature;
  Speed? windSpeed;
  Length? elevation;

  Provider weatherProvider;
  bool isDaily;

  final MapLocation location;

  Weather(this.weatherProvider, this.location, this.isDaily);

  Future<void> updateInfo() async {
    if (await location.getLocationInfo()) {
      if (pressure == null || temperature == null || windSpeed == null || elevation == null) {
        final data = [location.coordinates.toString()];
        if (isDaily) {
          data.add("daily");
        }
        elevation = Length(weatherProvider, data, "Elevation", type: ProviderData.elevation);
        pressure = Pressure(weatherProvider, data, "Atm Pressure");
        temperature = Temperature(weatherProvider, data, "Atm Temperature");
        windSpeed = Speed(weatherProvider, data, "Wind Speed", type: ProviderData.windSpeed);
      }
      await elevation!.getValue().whenComplete(() async {
          await pressure!.getValue();
          await temperature!.getValue();
          await windSpeed!.getValue();
      });
    }
  }

  Future<void> changeElevation(double value) async {
    await weatherProvider.setValue(ProviderData.elevation, [], value);
  }
}
