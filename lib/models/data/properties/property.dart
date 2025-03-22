import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';
import 'dart:async';
import 'property_unit.dart';

abstract class Property {
  double value = 0.0;
  PropertyUnit unit;
  Provider provider;
  ProviderData type;

  final List<String> source;
  final String name;

  Stream<double>? valueStream;
  int updateInterval = 5;

  Property(this.provider, this.source, this.name, {this.type = ProviderData.none, this.unit = PropertyUnit.none});

  void convertUnit(PropertyUnit to);
  Future<double> getValue();
}
