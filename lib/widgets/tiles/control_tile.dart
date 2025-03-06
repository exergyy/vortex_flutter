import 'package:flutter/material.dart';
import 'package:vortex/models/data/controls/control.dart';
import 'package:vortex/widgets/components/control_widget.dart';
import 'package:vortex/widgets/components/custom_card_widget.dart';

class ControlTile extends StatelessWidget {
  final List<Control> controls;

  const ControlTile({super.key, required this.controls});

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      child: ListView.separated(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: controls.length,
        separatorBuilder: (context, index) => Divider(
          thickness: 1,
          color: Theme.of(context).colorScheme.outline,
        ),
        itemBuilder: (context, index) => ControlWidget(control: controls[index]),
      )
    );
  }
}
