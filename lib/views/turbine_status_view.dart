import 'package:flutter/material.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/viewmodels/turbine_view_model.dart';
import 'package:vortex/widgets/components/header_widget.dart';
import 'package:vortex/widgets/tiles/chart_tile.dart';
import 'package:vortex/widgets/tiles/info_tile.dart';
import 'package:vortex/widgets/tiles/control_tile.dart';

class TurbineStatusView extends StatelessWidget {
  final viewModel = TurbineViewModel();
  TurbineStatusView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        appBar: AppBar(
          title: Text(viewModel.title),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          padding: AppStyle.padding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Container(
                padding: AppStyle.padding,
                height: MediaQuery.of(context).size.height * 0.3,
                child: Image.asset("images/turbine2.gif", fit: BoxFit.cover,)
              ),

              // HeaderWidget(data: "Weather"),

              HeaderWidget(data: "Readings"),
              InfoTile(properties: viewModel.turbine.esp32Readings!),

              HeaderWidget(data: "Control"),
              ControlTile(controls: viewModel.turbine.controls!),

              HeaderWidget(data: "Charts"),
              ChartTile(),
            ],
          ),
        ));
  }
}
