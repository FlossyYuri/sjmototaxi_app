import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sjmototaxi_app/constants.dart';

class TemplesUtils {
  // Base url for google maps nearbysearch
  // #1
  static const String _baseUrlNearBySearch =
      "https://maps.googleapis.com/maps/api/place/nearbysearch/json?";

  final String _placesApi = GOOGLE_API_KEY;

  Uri searchUrl(LatLng userLocation) {
    final api = "&key=$_placesApi";
    final radius = "&radius=10000";

    final location =
        "location=${userLocation.latitude},${userLocation.longitude}";

    const types = "&types=shopping_mall&types=restaurant";
    final url =
        Uri.parse(_baseUrlNearBySearch + location + types + radius + api);

    return url;
  }
}
