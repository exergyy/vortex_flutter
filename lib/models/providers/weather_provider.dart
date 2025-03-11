import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:open_meteo/open_meteo.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'dart:math';

class WeatherProvider extends Provider {
  @override
  Future<Object> getValue(ProviderData type, List<String>? data) async {
    final weather = WeatherApi(
        temperatureUnit: TemperatureUnit.celsius,
        windspeedUnit: WindspeedUnit.kmh);
    final coordinates = MapCoordinates.fromString(data![0]);

    // do elevation
    final res = await weather
        .requestJson(latitude: coordinates.x, longitude: coordinates.y, daily: {
      WeatherDaily.temperature_2m_max,
      WeatherDaily.wind_speed_10m_max,
    }, current: {
      WeatherCurrent.temperature_2m,
      WeatherCurrent.wind_speed_10m,
      WeatherCurrent.wind_direction_10m,
      WeatherCurrent.surface_pressure
    });

    if (data.contains("daily")) {
      return switch (type) {
        ProviderData.temperature => res["daily"]["temperature_2m_max"].map((e) => e.toDouble()).toList()[0],
        ProviderData.pressure => res["current"]["surface_pressure"],
        ProviderData.windSpeed =>
          "${res["daily"]["wind_speed_10m_max"].map((e) => e.toDouble()).toList()[0]},${res["current"]["wind_direction_10m"]}",
        _ => UnimplementedError()
      }.toString();
    } else {
      return switch (type) {
        ProviderData.temperature => res["current"]["temperature_2m"],
        ProviderData.pressure => res["current"]["surface_pressure"],
        ProviderData.windSpeed =>
          "${res["current"]["wind_speed_10m"]},${res["current"]["wind_direction_10m"]}",
        _ => UnimplementedError()
      }.toString();
    }
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) {
    // TODO: implement setValue
    throw UnimplementedError();
  }
}
