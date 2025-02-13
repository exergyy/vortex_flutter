import 'package:vortex/models/data/map/map_coordinates.dart';
import 'package:vortex/models/providers/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:osm_geocoder/osm_geocoder.dart';
import 'package:vortex/models/providers/provider_data.dart';

class LocationProvider extends Provider {

  Future<MapCoordinates?> _getUserLocation() async {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();
      Position position;

      if (!serviceEnabled) {
        return Future.error('Location services are disabled.');
      }

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return Future.error('Location permissions are denied');
        }
      } else if (permission == LocationPermission.deniedForever) {
        return Future.error(
            'Location permissions are permanently denied');
      }

      position = await Geolocator.getCurrentPosition();
      return MapCoordinates(position.latitude, position.longitude);
  }

  Future<String?> _getLocationName(MapCoordinates coordinates) async {
    return (await OSMGeocoder.findDetails(Coordinates(lat: coordinates.x, lon: coordinates.y))).displayName;
  }


  Future<MapCoordinates> _getLocationCoordinates(String name) async {
    var loc = (await OSMGeocoder.query(name)).first;
    return MapCoordinates(double.parse(loc.lat), double.parse(loc.lon));
  }

  @override
  Future<Object> getValue(ProviderData type, List<String>? data) async {
    if (type == ProviderData.location) {
    MapCoordinates? coordinates;
    String? name;

    if (data == null || data.isEmpty == true) {
      // get current user location
      try {
        coordinates = await _getUserLocation();
        name = await _getLocationName(coordinates!);
      } catch (e) {
        return (null, null);
      }
    } else if (data.length == 1) {
      // get coordinates from name
      coordinates = await _getLocationCoordinates(data[0]);
      name = data[0];
    } else if (data.length == 2) {
      // get name from coordinates
      coordinates = MapCoordinates(double.parse(data[0]), double.parse(data[1]));
      name = await _getLocationName(coordinates);
    }
    return (name, coordinates);
    }
    else {
      throw TypeError();
    }
  }

  @override
  Future<void> setValue(ProviderData type, List<String>? data, Object value) {
    // TODO: implement setValue
    throw UnimplementedError();
  }
}
