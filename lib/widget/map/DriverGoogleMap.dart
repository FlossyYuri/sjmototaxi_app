import 'dart:async';

import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/utils/index.dart';
import 'package:agotaxi/utils/map.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/utils/location.dart';
import 'package:hexcolor/hexcolor.dart';

class DriverGoogleMap extends StatefulWidget {
  const DriverGoogleMap({super.key});

  @override
  State<DriverGoogleMap> createState() => _DriverGoogleMapState();
}

class _DriverGoogleMapState extends State<DriverGoogleMap> {
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  StreamSubscription? _positionStreamSubscription;

  GoogleMapController? _controller;
  final List<Marker> _markers = [];

  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller!.setMapStyle(value);
  }

  LatLng currentPosition = const LatLng(-25.8858, 32.6129);

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double currentPositionRotation = 0;

  void createDocumentWithPosition() {
    FirebaseFirestore.instance
        .collection('online_drivers')
        .doc(authStoreController.auth['user']['uid'])
        .set({
      'name': authStoreController.auth['user']['name'],
      'position': {
        'latitude': currentPosition.latitude.toString(),
        'longitude': currentPosition.longitude.toString(),
      },
      'rotation': currentPositionRotation.toString(),
    });
  }

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 20,
    );
    var stream =
        Geolocator.getPositionStream(locationSettings: locationSettings);

    _positionStreamSubscription = stream.listen((position) {
      setState(() {
        currentPositionRotation = position.heading;
        currentPosition = CustomLocationUtils().getLatLngFromPosition(position);
        if (_controller == null) return;
        createDocumentWithPosition();
        CustomLocationUtils()
            .updateCameraPosition(_controller!, currentPosition);

        if (mapsStoreController.rideOptions.value.status == 'accepted') {
          double meters = getDistanceBetween(
            position.latitude,
            position.longitude,
            mapsStoreController.rideOptions.value.origin!.geometry.latitude,
            mapsStoreController.rideOptions.value.origin!.geometry.longitude,
          );
          if (meters < 300) {
            mapsStoreController.changeRideStatus('ready');
          }
        }

        if (mapsStoreController.rideOptions.value.status == 'running') {
          double meters = getDistanceBetween(
            position.latitude,
            position.longitude,
            mapsStoreController.rideOptions.value.destin!.geometry.latitude,
            mapsStoreController.rideOptions.value.destin!.geometry.longitude,
          );
          if (meters < 100) {
            mapsStoreController.changeRideStatus('arrived-destin');
          }
        }
      });
    });
  }

  Future<void> _setCurrentPosition() async {
    var value = await CustomLocationUtils().getCurrentPosition();
    setState(() {
      currentPosition = CustomLocationUtils().getLatLngFromPosition(value);
      if (_controller == null) return;
      CustomLocationUtils().updateCameraPosition(_controller!, currentPosition);
    });
  }

  void _drawPolilynes() {
    switch (mapsStoreController.rideOptions.value.status) {
      case 'accepted':
        _getPolylineToClient();
        break;
      default:
        if (mapsStoreController.rideOptions.value.origin != null)
          _getPolyline();
        break;
    }
  }

  @override
  void initState() {
    _loadMarkerIcons();
    super.initState();
  }

  @override
  void dispose() {
    if (_positionStreamSubscription != null) {
      _positionStreamSubscription!.cancel();
    }
    super.dispose();
  }

  Map<String, BitmapDescriptor> markerIcon = {};
  _loadMarkerIcons() async {
    markerIcon['current'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/current_position.png');
    markerIcon['origin'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/origin.png');
    markerIcon['destinYellow'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/destin1.png');
    markerIcon['destinRed'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/destin2.png');
    markerIcon['car'] =
        await CustomLocationUtils().getMarkerIconFromPng('assets/pngs/car.png');

    await _setCurrentPosition();
    _liveLocation();
    _drawPolilynes();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: currentPosition == null
              ? Center(child: Text("Loading"))
              : Stack(
                  children: [
                    GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          currentPosition.latitude,
                          currentPosition.longitude,
                        ),
                        zoom: 15.0,
                        tilt: 0,
                        bearing: 0,
                      ),
                      onMapCreated: onMapCreated,
                      polylines: Set<Polyline>.of(polylines.values),
                      markers: {
                        ...Set<Marker>.of(_markers),
                        Marker(
                          markerId: MarkerId("currentLocation"),
                          icon: markerIcon['current'] ??
                              BitmapDescriptor.defaultMarker,
                          position: LatLng(
                            currentPosition.latitude,
                            currentPosition.longitude,
                          ),
                          rotation: currentPositionRotation,
                        ),
                      },
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: HexColor('#9722FB'),
        // color: HexColor('#3A5DFB'),
        width: 4,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    var origin = mapsStoreController.rideOptions.value.origin!.geometry;
    var destin = mapsStoreController.rideOptions.value.destin!.geometry;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_API_KEY,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destin.latitude, destin.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      if (CustomLocationUtils().isSouthwest(origin, destin)) {
        moveCamera(_controller!, origin, destin);
      } else {
        moveCamera(_controller!, destin, origin);
      }
      _markers.clear();

      _markers.add(Marker(
        markerId: MarkerId("origin"),
        icon: markerIcon['origin']!,
        position: LatLng(
          origin.latitude,
          origin.longitude,
        ),
        anchor: Offset(0.5, 1.0),
      ));
      _markers.add(Marker(
        markerId: MarkerId("destinRed"),
        icon: markerIcon['destinRed']!,
        position: LatLng(
          destin.latitude,
          destin.longitude,
        ),
      ));
    }
    _addPolyLine();
  }

  _getPolylineToClient() async {
    var origin = currentPosition;
    var destin = mapsStoreController.rideOptions.value.origin!.geometry;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_API_KEY,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destin.latitude, destin.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      polylineCoordinates.clear();
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      if (CustomLocationUtils().isSouthwest(origin, destin)) {
        moveCamera(_controller!, origin, destin);
      } else {
        moveCamera(_controller!, destin, origin);
      }
      _markers.clear();
      _markers.add(Marker(
        markerId: MarkerId("destinRed"),
        icon: markerIcon['destinRed']!,
        position: LatLng(
          destin.latitude,
          destin.longitude,
        ),
      ));
    }
    _addPolyLine();
  }
}
