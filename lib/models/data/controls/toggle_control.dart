import 'package:vortex/models/providers/provider_data.dart';

import './control.dart';

class ToggleControl extends Control {
  ToggleControl(super.provider, super.source, super.name);

  @override
  Future<void> getValue() async {
    currentValue = false;
    //currentValue = await provider.getValue(ProviderData.Toggle, source) as bool;
  }

  @override
  Future<void> setValue(Object val) async {
    currentValue = val as bool;
    await provider.setValue(ProviderData.toggle, source, currentValue!);
  }
}
