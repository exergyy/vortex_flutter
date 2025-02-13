import '../../providers/provider.dart';

abstract class Control {
  final String name;
  Object? currentValue;
  final List<String> source;
  final Provider provider;

  Control(this.provider, this.source, this.name);
  Future<void> getValue();
  Future<void> setValue(Object val);
}
