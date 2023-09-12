import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomLocationUtils {
  Future<Position> getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  void updateCameraPosition(
      GoogleMapController controller, LatLng currentPosition) {
    controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: currentPosition, zoom: 15),
      ),
    );
  }

  LatLng getLatLngFromPosition(Position position) {
    return LatLng(position.latitude, position.longitude);
  }

  bool isSouthwest(LatLng point1, LatLng point2) {
    return (point1.latitude < point2.latitude) &&
        (point1.longitude < point2.longitude);
  }

  Future<BitmapDescriptor> getMarkerIconFromPng(String asset) async {
    return await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, asset);
  }
}
