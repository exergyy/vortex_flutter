import 'package:vortex/models/data/controls/control.dart';
import 'package:vortex/models/providers/provider_data.dart';

class VariableControl extends Control {
  double step;
  double max;
  double min;

  VariableControl(
      super.provider, super.source, super.name, this.min, this.max, this.step);

  Future<void> increamentValue() async {
    double newValue = (currentValue as double) + step;
    newValue = double.parse(newValue.toStringAsFixed(2));

    await setValue(newValue);
  }

  Future<void> decreamentValue() async {
    double newValue = (currentValue as double) - step;
    newValue = double.parse(newValue.toStringAsFixed(2));

    await setValue(newValue);
  }

  @override
  Future<Object?> getValue() async {
    currentValue = await provider.getValue(ProviderData.variable, source) as double;
    return currentValue;
  }

  @override
  Future<void> setValue(Object val) async {
    double? newValue = switch (val) {
      String() => double.tryParse(val),
      double() => val,
      _ => 0
    };

    if (!(newValue == null || newValue > max || newValue < min)) {
      currentValue = newValue;
      await provider.setValue(ProviderData.variable, source, currentValue!);
    }
  }
}
