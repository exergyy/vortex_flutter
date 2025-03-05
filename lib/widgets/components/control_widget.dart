import 'package:flutter/material.dart';
import 'package:vortex/app_style.dart';
import 'package:vortex/models/data/controls/control.dart';
import 'package:vortex/models/data/controls/options_control.dart';
import 'package:vortex/models/data/controls/toggle_control.dart';
import 'package:vortex/models/data/controls/variable_control.dart';

class ControlWidget extends StatefulWidget {
  final Control control;

  const ControlWidget({super.key, required this.control});

  @override
  State<ControlWidget> createState() => _ControlWidgetState();
}

class _ControlWidgetState extends State<ControlWidget> {
  void _updateControl() async {
    if (widget.control.currentValue == null) {
      await widget.control.getValue();
      setState(() {});
    }
  }

  @override
  void initState() {
    _updateControl();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(_getControlIcon(widget.control)),
      title: Text(widget.control.name),
      trailing: SizedBox(width: 200, child: _controlBuilder()));
  }

  IconData _getControlIcon(Control control) {
    return switch (control) {
      ToggleControl() => Icons.power_settings_new_rounded,
      VariableControl() => Icons.vertical_distribute_rounded,
      OptionsControl() => Icons.view_list_rounded,
      _ => Icons.no_sim_outlined
    };
  }

  Widget _controlBuilder() {
    switch (widget.control) {
      case ToggleControl():
      return toggleWidget(widget.control as ToggleControl);
      case VariableControl():
      return variableWidget(widget.control as VariableControl);
      case OptionsControl():
      return optionsWidget(widget.control as OptionsControl);
      default:
      return Container();
    }
  }

  Widget toggleWidget(ToggleControl control) {
    return Switch(
      value: control.currentValue as bool,
      activeColor: Theme.of(context).colorScheme.secondary,
      onChanged: (state) async {
        await widget.control.setValue(state);
        setState(() {});
    });
  }

  Widget variableWidget(VariableControl control) {
    final controller = TextEditingController(text: control.currentValue.toString());
    return SizedBox(
      width: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              await control.increamentValue();
              setState(() {});
            },
            icon: Icon(Icons.add)),
          Flexible(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: AppStyle.padding,
              ),
              onSubmitted: (value) async {
                await control.setValue(value);
                setState(() {});
              },
            ),
          ),
          IconButton(
            onPressed: () async {
              await control.decreamentValue();
              setState(() {});
            },
            icon: Icon(Icons.remove))
        ],
      ),
    );
  }

  Widget optionsWidget(OptionsControl control) {
    var buttons = control.currentValue as (List<String>, List<bool>);
    return ToggleButtons(
      selectedBorderColor: Theme.of(context).colorScheme.secondary,
      isSelected: buttons.$2,
      onPressed: (index) {
        setState(() {
            for (int i = 0; i < buttons.$2.length; i++) {
              if (i == index) {
                buttons.$2[i] = true;
              } else {
                buttons.$2[i] = false;
              }
            }
        });
      },
      children: buttons.$1.map((e) => Text(e)).toList());
  }
}
