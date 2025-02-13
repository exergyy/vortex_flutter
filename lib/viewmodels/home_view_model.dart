import 'package:vortex/views/turbine_status_view.dart';
import 'package:vortex/views/weather_map_view.dart';

class HomeViewModel {

  int currentView = 0;

  final views = [
    TurbineStatusView(),
    WeatherMapView()
  ];


}