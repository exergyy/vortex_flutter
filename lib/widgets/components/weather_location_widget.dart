import 'dart:math';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/map/weather.dart';
import 'package:vortex/models/data/properties/length.dart';
import 'package:vortex/models/data/properties/speed.dart';
import 'package:vortex/models/data/turbine.dart';

class WeatherLocationWidget extends StatefulWidget {
  final Weather weather;
  final double iconSize;
  final Turbine turbine;

  const WeatherLocationWidget({super.key, required this.weather, required this.iconSize, required this.turbine});

  @override
  State<StatefulWidget> createState() => _WeatherLocationWidgetState();
}

class _WeatherLocationWidgetState extends State<WeatherLocationWidget> {
  double requiredEnergy = 0;

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

  void _getEstimatedDimensions(Speed windSpeed) {
    final t = widget.turbine;
    double airDensity = 1.2;
    double constant = pow((5 / 18), 3).toDouble() * 0.5 * airDensity * t.cp * t.mechEff * 24 * 0.001;
    double projectedArea = requiredEnergy / (constant * pow(windSpeed.value, 3).toDouble());
    t.diameter = round(sqrt(projectedArea / t.aspectRatio), decimals: 2);
    t.height = round(t.aspectRatio * t.diameter, decimals: 2);
  }

  void _buildWindow(Speed? windSpeed, IconData dir, Length? elevation) {
    final energyController = TextEditingController(text: requiredEnergy.toString());
    final elevController = TextEditingController(text: widget.weather.elevation?.value.toString());

    if (windSpeed != null && elevation != null) {
      showDialog(
        context: context,
        builder: (c) => StatefulBuilder(
          builder: (c, setState) => AlertDialog(
            title: const Text("Details"),
            content: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text("Wind Speed:"),
                    trailing: SizedBox(
                      width: 80,
                      child: Row(children: [
                          Text("${windSpeed!.value}"),
                          Icon(dir)
                  ]))),

                  ListTile(
                    title: Text("Required Annual Energy:"),
                    trailing:
                    SizedBox(
                      width: 50,
                      child:
                      TextField(
                        controller: energyController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: AppStyle.padding,
                        ),
                        onChanged: (v) {
                          double? input = double.tryParse(v);
                          if (input == null || input < 0) return;
                          requiredEnergy = input;

                          _getEstimatedDimensions(windSpeed!);
                          setState(() {});
                        },
                    )),
                  ),

                  ListTile(
                    title: Text("Elevation:"),
                    trailing:
                    SizedBox(
                      width: 50,
                      child:
                      TextField(
                        controller: elevController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: AppStyle.padding,
                        ),
                        onChanged: (v) async {
                          double? input = double.tryParse(v);
                          if (input == null || input < 0) return;
                          await widget.weather.changeElevation(input);
                          await widget.weather.updateInfo();
                          windSpeed = widget.weather.windSpeed;

                          _getEstimatedDimensions(windSpeed!);
                          setState(() {});
                        },
                    )),
                  ),

                  ListTile(title: Text("Recommended Turbine:")),
                  ListTile(title: Text("Type: "), trailing: Text(widget.turbine.type.toString().split('.')[1])),
                  ListTile(title: Text("Height: "), trailing: Text(widget.turbine.height.toString())),
                  ListTile(title: Text("Diameter: "), trailing: Text(widget.turbine.diameter.toString())),
                ],
              ),
            ),
          )
        )
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final windSpeed = widget.weather.windSpeed;
    final elevation = widget.weather.elevation;
    final iconSize = widget.iconSize;
    final dir = _windDirectionIcon(windSpeed?.direction);

    return GestureDetector(
      onTap: () => _buildWindow(windSpeed, dir, elevation),
      child: Container(
        decoration: BoxDecoration(color: Colors.blueAccent, borderRadius: AppStyle.borderRadius),
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
                fontSize: iconSize)
            ),
            Icon(dir, color: Colors.white, size: iconSize)
          ],
        ),
      ),
    );
  }
}
