import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/data/properties/speed.dart';

class WeatherLocationWidget extends StatefulWidget {
  final Weather? weather;
  final double iconSize;

  const WeatherLocationWidget({super.key, required this.weather, required this.iconSize});

  @override
  State<StatefulWidget> createState() => _WeatherLocationWidgetState();
}

class _WeatherLocationWidgetState extends State<WeatherLocationWidget> {

  IconData _windDirectionIcon(double? angle) {
    if (angle == null) {
      return Icons.question_mark_rounded;
    } else if (angle >= 337.5 || angle < 22.5) {
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

  double _getEstimatedPower(Speed velocity) {
    double cp = 0.4;
    double mechEff = 0.8;
    double aspectRatio = 1.1;
    double height = 1.5;
    double diameter = height / aspectRatio;
    double projectedArea = height * diameter;
    double airDensity = 1.2;

    double constant = pow((5 / 18), 3).toDouble() * 0.5 * airDensity * projectedArea * cp * mechEff * 24 * 0.001;
    return round(constant * pow(velocity.value, 3).toDouble(), decimals: 2);
  }

  void _buildWindow(Speed? velocity, IconData dir) {
    if (velocity != null) {
      showDialog(
        context: context,
        builder: (c) => AlertDialog(
          title: const Text("Details"),
          content: SizedBox(
            height: 50,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                    Text("Wind Speed: ${velocity.value}"),
                    Icon(dir)
                ]),
                Text("Estimated Power: ${_getEstimatedPower(velocity)} kWh")
              ],
            ),
          ),
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    final windSpeed = widget.weather?.windSpeed;
    final iconSize = widget.iconSize;
    final dir = _windDirectionIcon(windSpeed?.direction);

    return GestureDetector(
      onTap: () => _buildWindow(windSpeed, dir),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blueAccent, borderRadius: AppStyle.borderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.wind_power, color: Colors.white, size: iconSize),
            Text(
              windSpeed?.toString() ?? "Loading",
              textAlign: TextAlign.center,
              style: TextStyle(
                decoration: TextDecoration.none,
                color: Colors.white,
                fontSize: iconSize)),
            Icon(dir, color: Colors.white, size: iconSize)
          ],
        ),
      ),
    );
  }
}
