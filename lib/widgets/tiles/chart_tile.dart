import 'package:flutter/material.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/properties/temperature.dart';
import 'package:vortex/models/providers/dummy_provider.dart';
import 'package:vortex/widgets/components/custom_card_widget.dart';
import 'package:vortex/widgets/components/property_chart_widget.dart';

class ChartTile extends StatelessWidget {
  const ChartTile({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(child: Padding(
      padding: AppStyle.padding,
      child: PropertyChartWidget(property: Temperature(DummyProvider(), ["3", "4"], "Power")),
    ));
  }
}