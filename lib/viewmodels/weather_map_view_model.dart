import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/providers/location_provider.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/weather_provider.dart';

class WeatherMapViewModel {
  final String title = "Wind Speed Map";
  final Provider weatherProvider = WeatherProvider();
  final Provider locationProvider = LocationProvider();

  late Weather focusedLocation;
  List<Weather> forecast = [];

  WeatherMapViewModel() {
    // lat 25 - 32
    // long 30 - 32
    forecast = [
      Weather(weatherProvider, MapLocation(locationProvider, coordinates: MapCoordinates(30.0444, 31.2358)), true),
    ];
    focusedLocation = forecast[0];
  }

  Future<List<Weather>> updateModel() async {
    for (var w in forecast) {
      await w.updateInfo();
    }
    return forecast;
  }

  void populateSurroundingLocations(MapLocation location, {double step = 0.05}) {
    var lat = location.coordinates!.x;
    var lng = location.coordinates!.y;

    for(double i = lat - step; i <= lat + step; i += step) {
      for (double j = lng - step; j <= lng + step; j += step) {
        if (i == lat && j == lng) continue;
        forecast.add(Weather(weatherProvider, MapLocation(locationProvider, coordinates: MapCoordinates(i, j)), true));
      }
    }

  }
}
