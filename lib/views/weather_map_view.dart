import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/viewmodels/weather_map_view_model.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'package:vortex/widgets/components/weather_location_widget.dart';

class WeatherMapView extends StatefulWidget {
  const WeatherMapView({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherMapViewState();
}

class _WeatherMapViewState extends State<WeatherMapView> {
  final viewModel = WeatherMapViewModel();
  final _mapController = MapController();
  double _mapZoom = 14;

  Marker buildMarker(Weather? weather) {
    if (weather == null || weather.location.coordinates == null) {
      return Marker(point: LatLng(0, 0), child: SizedBox());
    }


    return Marker(
      width: 120 * _mapZoom * 0.1,
      height: 20 * _mapZoom * 0.1,
      point: weather.location.coordinates!.toLatLng(),
      child: WeatherLocationWidget(weather: weather, iconSize: 10 * _mapZoom * 0.1, turbine: viewModel.turbine,)
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        FutureBuilder<List<Weather>>(
          future: viewModel.updateModel(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: CircularProgressIndicator());
            }
            return FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter:
                viewModel.focusedLocation.location.coordinates?.toLatLng() ?? LatLng(0, 0),
                initialZoom: _mapZoom,
                onPositionChanged: (camera, hasGesture) {
                  _mapZoom = camera.zoom;
                  setState(() {});
                },
              ),
              children: [
                TileLayer(urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png'),
                MarkerLayer(
                  markers: snapshot.data!
                  .map((w) => buildMarker(w))
                  .toList())
              ],

            );
          },
        ),

        Padding(
          padding: AppStyle.padding,
          child: Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              child: const Icon(Icons.search_rounded),
              onPressed: () async {
                LocationData? locationData = await LocationSearch.show(
                  context: context, mode: Mode.overlay);

                viewModel.forecast.add(Weather(
                    viewModel.weatherProvider,
                    MapLocation(viewModel.locationProvider,
                      name: locationData!.address,
                      coordinates: MapCoordinates(locationData.latitude, locationData.longitude)), true));
                viewModel.focusedLocation = viewModel.forecast.last;
                viewModel.populateSurroundingLocations(viewModel.focusedLocation.location);

                setState(() {
                    _mapController.move(
                      viewModel.focusedLocation.location.coordinates!
                      .toLatLng(),
                      15);
                });
            }),
          ),
        )
    ]);
  }
}
