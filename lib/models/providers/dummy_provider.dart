import 'dart:math';

import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';

class DummyProvider extends Provider{
  @override
  Future<Object> getValue(ProviderData type, List<String>? data) {
    final max = int.parse(data![1]);
    final min = int.parse(data[0]);

    return Future<String>.delayed(Duration(seconds: 0), () => (min + Random().nextInt(max - min)).toString());
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) async {
    print("value set");
  }
}
