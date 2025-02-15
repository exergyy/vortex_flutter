import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/properties/property.dart';

class PropertyChartWidget extends StatefulWidget {
  final Property property;

  const PropertyChartWidget({super.key, required this.property});

  @override
  State<PropertyChartWidget> createState() => _PropertyChartWidgetState();
}

class _PropertyChartWidgetState extends State<PropertyChartWidget> {
  final StreamController<List<FlSpot>> _chartDataStream = StreamController();
  final List<FlSpot> _chartData = [];
  int _xInterval = 0;
  
  
  @override
  void initState() {
    super.initState();
    widget.property.valueStream!.listen((v) {
      _xInterval += widget.property.updateInterval;
      _chartData.add(FlSpot((_xInterval).toDouble(), v));

      if (_chartData.length > 10) _chartData.removeAt(0);

      _chartDataStream.sink.add(_chartData);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: _chartDataStream.stream,
     builder: (c, s) {
          if(s.hasError) {
            return Center(child: Text(s.error.toString()));
          }
          else if (s.data == null || !s.hasData) {
            return CircularProgressIndicator();
          }
        
        return SizedBox(
          height: MediaQuery.of(c).size.height * 0.5,
          child: LineChart(
            LineChartData(
              minY: 0,
              maxY: 5,
              baselineY: 1,

              gridData: FlGridData(show: false),

              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Theme.of(c).colorScheme.secondary)
              ),

              titlesData: FlTitlesData(
                show: true,

                topTitles: AxisTitles(
                  axisNameSize: 20,
                  axisNameWidget: Text(widget.property.name)
                ),

                rightTitles: AxisTitles(
                  axisNameSize: 20,
                  axisNameWidget: Text(" "),
                  sideTitles: SideTitles(showTitles: false)),

                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => value % 1 == 0? Text(value.toString()) : Container()
                  )
                ),

                
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => value % 1 == 0? Text(value.toString()) : Container()
                  )
                )

              ),

              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) => Theme.of(c).colorScheme.surfaceBright,
                )
              ),


              lineBarsData: [LineChartBarData(
                
                spots: s.data!,
                isCurved: true,
                color: Theme.of(c).colorScheme.primary,
                barWidth: 2,
                isStrokeCapRound: true,


                dotData: FlDotData(
                  show: true,
                  getDotPainter: (p0, p1, p2, p3) => FlDotCirclePainter(
                    color: Theme.of(c).colorScheme.surface,
                    strokeColor: Theme.of(c).colorScheme.primary,
                    strokeWidth: 2,
                    radius: 2,
                  ),
                ),


                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(c).colorScheme.secondary.withAlpha(40),
                ),
              )],
            )
          ),
        );
     });
  }
}