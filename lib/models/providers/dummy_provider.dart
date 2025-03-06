import 'dart:math';

import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';

class DummyProvider extends Provider {
  @override
  Future<Object> getValue(ProviderData type, List<String>? data) {
    switch (type) {
      case ProviderData.toggle:
        return Future.value(false);
      case ProviderData.variable:
        return Future.value(0.0);

      default:
        final max = double.parse(data![1]);
        final min = double.parse(data[0]);

        return Future<String>.delayed(
            Duration(seconds: 0),
            () => (min +
                    Random().nextDouble() +
                    Random().nextInt(max.toInt() - min.toInt()))
                .toString());
    }
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) async {
  }
}
