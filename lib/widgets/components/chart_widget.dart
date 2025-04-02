import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/chart/chart_data.dart';
import 'dart:async';

import 'package:vortex/models/data/chart/chart_point.dart';

class ChartWidget extends StatefulWidget {
  final ChartData data;
  final int visiblePointsCount;

  const ChartWidget({super.key, required this.data, required this.visiblePointsCount});

  @override
  State<ChartWidget> createState() => _ChartWidgetState();
}

class _ChartWidgetState extends State<ChartWidget> {
  Stream<List<FlSpot>> getDataStream(StreamController<List<ChartPoint>> controller) {
    return controller.stream.map((l) => l.map((e) => e.toFlSpot()).toList());
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getDataStream(widget.data.pointsController),
      builder: (c, s) {
        if (s.hasError) {
          return Center(child: Text(s.error.toString()));
        }

        return SizedBox(
          height: MediaQuery.of(c).size.height * 0.5,
          child: LineChart(LineChartData(
              minY: widget.data.minValue,
              maxY: widget.data.maxValue,
              baselineY: widget.data.baseValue,
              gridData: FlGridData(show: false),
              borderData: FlBorderData(
                show: true,
                border: Border.all(color: Theme.of(c).colorScheme.secondary)),
              titlesData: FlTitlesData(
                show: true,
                topTitles: AxisTitles(
                  axisNameSize: 40,
                  axisNameWidget: Text(widget.data.title)),
                rightTitles: AxisTitles(
                  axisNameSize: 40,
                  sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  axisNameWidget: Text(widget.data.getAxisName(ChartDirection.left)),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Padding(padding:AppStyle.padding,
                      child: Text(widget.data.formatVisibleValue(ChartDirection.left, value))))),
                bottomTitles: AxisTitles(
                  axisNameWidget: Padding(padding:AppStyle.padding,
                    child: Text(widget.data.getAxisName(ChartDirection.bottom))),
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) => Padding(padding:AppStyle.padding,
                      child: Text(widget.data.formatVisibleValue(ChartDirection.bottom, value)))))),
              lineTouchData: LineTouchData(
                touchTooltipData: LineTouchTooltipData(
                  getTooltipColor: (touchedSpot) =>
                  Theme.of(c).colorScheme.surfaceBright,
              )),
              lineBarsData: [
                LineChartBarData(
                  spots: s.data ?? [],
                  isCurved: true,
                  color: Theme.of(c).colorScheme.primary,
                  barWidth: 2,
                  isStrokeCapRound: false,
                  preventCurveOverdraw: true,
                  dotData: FlDotData(
                    show: false,
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
                )
              ],
          )),
        );
    });
  }
}
