import 'package:vortex/models/data/controls/control.dart';

class OptionsControl extends Control { 

  //@override
  //bool get currentValue => super.currentValue as bool;

  OptionsControl(super.provider, super.source, super.name);

  @override
  Future<void> getValue() {
    // TODO: implement getValue
    throw UnimplementedError();
  }

  @override
  Future<void> setValue(Object val) {
    // TODO: implement setValue
    throw UnimplementedError();
  }
}