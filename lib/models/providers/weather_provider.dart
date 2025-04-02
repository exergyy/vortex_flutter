import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:vortex/models/providers/provider_data.dart';

class WeatherProvider extends Provider {
  final weather = WeatherApi(temperatureUnit: TemperatureUnit.celsius, windspeedUnit: WindspeedUnit.kmh);

  double _elevation = 40;
  Map<String, Map<String, dynamic>>  requests = {};

  Future<Map<String, dynamic>> _getRequest(double x, double y, double elevation) async {
    if (requests.containsKey("$x,$y,$elevation")) {
      return Future.value(requests["$x,$y,$elevation"]);
    } else {
      final res = await weather.requestJson(latitude: x, longitude: y, elevation: elevation,
        daily: {
          WeatherDaily.temperature_2m_max,
          WeatherDaily.wind_speed_10m_max,
        }, current: {
          WeatherCurrent.temperature_2m,
          WeatherCurrent.wind_speed_10m,
          WeatherCurrent.wind_direction_10m,
          WeatherCurrent.surface_pressure
      });

      requests["$x,$y,$elevation"] = res;
      return res;
    }
  }

  @override
  Future<Object> getValue(ProviderData type, List<String>? data) async {
    final coordinates = MapCoordinates.fromString(data![0]);
    final res = await _getRequest(coordinates.x, coordinates.y, _elevation);

    if (data.contains("daily")) {
      return switch (type) {
        ProviderData.elevation => res["elevation"],
        ProviderData.temperature => res["daily"]["temperature_2m_max"].map((e) => e.toDouble()).toList()[0],
        ProviderData.pressure => res["current"]["surface_pressure"],
        ProviderData.windSpeed => "${res["daily"]["wind_speed_10m_max"].map((e) => e.toDouble()).toList().reduce((a,b) => a > b ? a : b)}"
                                  ",${res["current"]["wind_direction_10m"]}",
        _ => UnimplementedError()
      }.toString();
    } else {
      return switch (type) {
        ProviderData.elevation => res["elevation"],
        ProviderData.temperature => res["current"]["temperature_2m"],
        ProviderData.pressure => res["current"]["surface_pressure"],
        ProviderData.windSpeed => "${res["current"]["wind_speed_10m"]},${res["current"]["wind_direction_10m"]}",
        _ => UnimplementedError()
      }.toString();
    }
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) {
    switch(type) {
      case ProviderData.elevation:
        _elevation = value as double;
        return Future.value();
      default:
        throw UnimplementedError();
    }
  }
}
