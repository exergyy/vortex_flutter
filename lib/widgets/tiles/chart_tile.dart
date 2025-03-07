import 'package:flutter/material.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/chart/chart_data.dart';
import 'package:vortex/widgets/components/custom_card_widget.dart';
import 'package:vortex/widgets/components/chart_widget.dart';

class ChartTile extends StatelessWidget {
  final List<ChartData> charts;
  const ChartTile(this.charts, {super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      child: Padding(
        padding: AppStyle.padding,
        child: ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: charts.length,
          separatorBuilder: (context, index) => Divider(
            thickness: 1,
            color: Theme.of(context).colorScheme.outline,
          ),
          itemBuilder: (context, index) => ChartWidget(data: charts[index], visiblePointsCount: 10,),
        )
    ));
  }
}
