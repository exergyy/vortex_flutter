import 'package:latlong2/latlong.dart';

class MapCoordinates {
  final double x;
  final double y;

  MapCoordinates(this.x, this.y);

  @override
  String toString() => "$x,$y";

  static MapCoordinates fromString(String? str) { 
    var res = str?.split(",").map((e) => double.tryParse(e)).toList();
    return MapCoordinates(res?.first ?? 0, res?.last ?? 0);
  }

  LatLng toLatLng() => LatLng(x, y);
}