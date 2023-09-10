import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:agotaxi/constants.dart';
import 'dart:convert';

String latLngToString(LatLng coordinates) {
  return '${coordinates.latitude.toString()},${coordinates.longitude.toString()}';
}

Future<String> performReverseGeocoding(LatLng coordinates) async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${coordinates.latitude},${coordinates.longitude}&key=$GOOGLE_API_KEY'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final formattedAddress = data['results'][0]['formatted_address'];
    return formattedAddress;
  } else {
    print('Failed to perform reverse geocoding');
    return '';
  }
}

Future<List<dynamic>> textSearchGoogleMapsPlaces(
    String query, LatLng latLng) async {
  final response = await http.get(Uri.parse(
      'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$query&key=$GOOGLE_API_KEY&location=${latLngToString(latLng)}'));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);

    final decodedRes = await jsonDecode(response.body);
    final results = await decodedRes['results'] as List<dynamic>;
    return results;
  } else {
    print('Failed to perform reverse geocoding');
    return [];
  }
}
