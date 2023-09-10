import 'dart:convert' as convert;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:agotaxi/utils/temple.dart';

Future<Map<String, dynamic>> postRequest(
    String endpoint, Map<String, dynamic> body) async {
  var url = Uri.https('ergo.flossyyuri.com', '/api/v1/$endpoint');

  var response = await http.post(url, body: body);
  var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
  return {'statusCode': response.statusCode, 'jsonResponse': jsonResponse};
}

Future<List<dynamic>> getPlaces(LatLng userLocation) async {
  final res = await http.get(TemplesUtils().searchUrl(userLocation));
  final decodedRes = await convert.jsonDecode(res.body);
  final results = await decodedRes['results'] as List<dynamic>;
  return results;
}
