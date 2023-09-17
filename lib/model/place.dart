import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPlace {
  String name;
  String? place_id;
  LatLng geometry;

  GoogleMapsPlace(this.name, this.place_id, this.geometry);
  factory GoogleMapsPlace.fromMap(Map<String, dynamic> place) {
    return GoogleMapsPlace(
        place['name'],
        place['place_id'],
        LatLng(double.parse(place['geometry']['latitude']),
            double.parse(place['geometry']['longitude'])));
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'place_id': place_id,
      'geometry': {
        'latitude': geometry.latitude.toString(),
        'longitude': geometry.longitude.toString(),
      }
    };
  }

  String toString() {
    return '$name,$place_id,${geometry.toString()}';
  }
}
