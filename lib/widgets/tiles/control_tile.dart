import 'package:flutter/material.dart';
import 'package:vortex/models/data/controls/control.dart';
import 'package:vortex/widgets/components/custom_card_widget.dart';
import '../components/control_widget.dart';

class ControlTile extends StatelessWidget {
  final Future<List<Control>>? controlsFunction;

  const ControlTile({super.key, required this.controlsFunction});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      child: FutureBuilder(
          future: controlsFunction,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: CircularProgressIndicator());
            }
            var controls = snapshot.data!;
            return ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: controls.length,
              separatorBuilder: (context, index) => Divider(
                thickness: 1,
                color: Theme.of(context).colorScheme.outline,
              ),
              itemBuilder: (context, index) =>
                  ControlWidget(control: controls[index]),
            );
          }),
    );
  }
}
