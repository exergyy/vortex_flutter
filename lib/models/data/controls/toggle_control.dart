import 'package:vortex/models/providers/provider_data.dart';

import './control.dart';

class ToggleControl extends Control {
  ToggleControl(super.provider, super.source, super.name);

  @override
  Future<Object?> getValue() async {
    currentValue = await provider.getValue(ProviderData.toggle, source);
    return currentValue;
  }

  @override
  Future<void> setValue(Object val) async {
    currentValue = val as bool;
    await provider.setValue(ProviderData.toggle, source, currentValue!);
  }
}
