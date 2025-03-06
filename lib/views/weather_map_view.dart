import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/data/map/map_location.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/viewmodels/weather_map_view_model.dart';
import 'package:flutter_location_search/flutter_location_search.dart';
import 'dart:math';

class WeatherMapView extends StatefulWidget {
  const WeatherMapView({super.key});

  @override
  State<StatefulWidget> createState() => _WeatherMapViewState();
}

class _WeatherMapViewState extends State<WeatherMapView> {
  final viewModel = WeatherMapViewModel();
  final _mapController = MapController();
  double _mapZoom = 14;

  IconData directionToIcon(double? angle) {
    if(angle == null) {
      return Icons.question_mark_rounded;
    }
    else if (angle >= 337.5 || angle < 22.5) {
      return Icons.arrow_upward;
    } else if (angle >= 22.5 && angle < 67.5) {
      return Icons.north_east;
    } else if (angle >= 67.5 && angle < 112.5) {
      return Icons.arrow_forward;
    } else if (angle >= 112.5 && angle < 157.5) {
      return Icons.south_east;
    } else if (angle >= 157.5 && angle < 202.5) {
      return Icons.arrow_downward;
    } else if (angle >= 202.5 && angle < 247.5) {
      return Icons.south_west;
    } else if (angle >= 247.5 && angle < 292.5) {
      return Icons.arrow_back;
    } else {
      return Icons.north_west;
    }
  }

  Marker buildMarker(Speed? velocity, MapCoordinates? coordinates) {
    if (coordinates == null) return Marker(point: LatLng(0, 0), child: SizedBox());

    var dir = directionToIcon(velocity?.direction);

    final markerWidth = 120 * _mapZoom * 0.1;
    final markerHeight = 20 * _mapZoom * 0.1;
    final iconSize = 10 * _mapZoom * 0.1;

    return Marker(
      point: coordinates.toLatLng(),
      width: markerWidth,
      height: markerHeight,
      child: GestureDetector(
        onTap: () {
          if (velocity != null) {
            showDialog(context: context,
              builder: (c) => AlertDialog(
                title: const Text("Details"),
                content: SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [Text("Wind Speed: ${velocity.value}"),  Icon(dir)]),
                      Text("Estimated Power: ${round(0.009 * pow(velocity.value, 3), decimals: 2)} KWh")
                    ],
                  ),
            ),));
        }},
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blueAccent, borderRadius: AppStyle.borderRadius),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.wind_power, color: Colors.white, size: iconSize),
              Text(
                velocity?.toString() ?? "Loading",
                textAlign: TextAlign.center,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  color: Colors.white,
                  fontSize: iconSize),
              ),
              Icon(dir, color: Colors.white, size: iconSize)
            ],
          ),
        ),
    ));
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
                  .map((w) => buildMarker(
                      w.windSpeed, w.location.coordinates))
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
                      coordinates: MapCoordinates(locationData.latitude, locationData.longitude))));
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
