import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/providers/location_provider.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:vortex/models/providers/provider_data.dart';

class MapLocation {
  MapCoordinates? coordinates;
  String? name;
  Provider provider;

  MapLocation(this.provider, {this.name, this.coordinates});

  Future<bool> getLocationInfo() async {
    if (provider is LocationProvider) {
      List<String>? parameters;

      if (name?.isNotEmpty == true) {
        parameters = [name!];
      } else {
        parameters = coordinates?.toString().split(",");
      }

      var res = (await provider.getValue(ProviderData.location, parameters)) as (String?, MapCoordinates?);

      name = res.$1;
      coordinates = res.$2;
      
      return !(name == null && coordinates == null);
    } else {
      throw TypeError();
    }
  }
}