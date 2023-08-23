import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPlace {
  final String name;
  final String? place_id;
  final LatLng geometry;

  GoogleMapsPlace(this.name, this.place_id, this.geometry);
}
