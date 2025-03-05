import 'package:flutter/material.dart';
import '../../app_style.dart';
import '../../models/data/properties/pressure.dart';
import '../../models/data/properties/property.dart';
import '../../models/data/properties/temperature.dart';
import '../../models/data/properties/wind_speed.dart';
import 'dart:developer';

class PropertyWidget extends StatefulWidget {
  final Property property;

  const PropertyWidget({super.key, required this.property});

  @override
  State<PropertyWidget> createState() => _PropertyWidgetState();
}

class _PropertyWidgetState extends State<PropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppStyle.padding,
      child: StreamBuilder<double>(
        stream: widget.property.valueStream,
        builder: (c, s) {
          String displayValue;
          if (s.hasError) {
            debugPrint("[ERROR] Couldn't fetch data of property (${widget.property.source}), ${s.error.toString()}");
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(Icons.error),
                Text("Error")]);
          } else if (!s.hasData) {
            return Padding(padding: EdgeInsets.all(50),
              child: SizedBox(
                width: 50, child: LinearProgressIndicator()));
          } else {
            displayValue = widget.property.toString();
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: AppStyle.padding,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_getPropertyIcon(widget.property)),
                    Text(" ${widget.property.name}")
              ])),
              Padding(
                padding: AppStyle.padding, child: Text(displayValue))
          ]);
    }));
  }

  IconData _getPropertyIcon(Property prop) {
    return switch (prop) {
      Temperature() => Icons.thermostat,
      Pressure() => Icons.speed,
      WindSpeed() => Icons.wind_power,
      _ => Icons.no_sim_outlined
    };
  }
}
