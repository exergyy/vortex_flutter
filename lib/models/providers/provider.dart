import 'package:vortex/models/providers/provider_data.dart';

abstract class Provider {
  Future<Object> getValue(ProviderData type, List<String>? data);
  Future<void> setValue(ProviderData type, List<String>? data, Object value);
}