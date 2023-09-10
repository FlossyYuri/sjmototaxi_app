import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/utils/location.dart';

class DriverGoogleMap extends StatefulWidget {
  DriverGoogleMap({super.key});

  @override
  State<DriverGoogleMap> createState() => _DriverGoogleMapState();
}

class _DriverGoogleMapState extends State<DriverGoogleMap> {
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());

  GoogleMapController? _controller;
  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller!.setMapStyle(value);
  }

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void setCurrentMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/current_position.png")
        .then((icon) {
      currentLocationIcon = icon;
    });
  }

  LatLng currentPosition = const LatLng(-25.8858, 32.6129);

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double currentPositionRotation = 0;

  void _liveLocation() {
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5,
    );

    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position position) {
      setState(() {
        currentPositionRotation = position.heading;
        currentPosition = CustomLocationUtils().getLatLngFromPosition(position);
        if (_controller == null) return;
        CustomLocationUtils()
            .updateCameraPosition(_controller!, currentPosition);
      });
    });
  }

  void _setCurrentPosition() {
    CustomLocationUtils().getCurrentPosition().then((value) {
      setState(() {
        currentPosition = CustomLocationUtils().getLatLngFromPosition(value);
        if (_controller == null) return;
        CustomLocationUtils()
            .updateCameraPosition(_controller!, currentPosition);
      });
    });
  }

  @override
  void initState() {
    setCurrentMarkerIcon();
    _setCurrentPosition();
    _getPolyline();
    _liveLocation();
    super.initState();
  }

  bool _loading = false;

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
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
                        Marker(
                          markerId: MarkerId("currentLocation"),
                          icon: currentLocationIcon,
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
        color: Theme.of(context).primaryColor,
        width: 4,
        points: polylineCoordinates);
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    var origin = mapsStoreController.newRide.value.origin!.geometry;
    var destin = mapsStoreController.newRide.value.destiny!.geometry;
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_API_KEY,
        PointLatLng(origin.latitude, origin.longitude),
        PointLatLng(destin.latitude, destin.longitude),
        travelMode: TravelMode.driving);
    if (result.points.isNotEmpty) {
      mapsStoreController.rideOptions.value.treatDistance(
        result.distanceValue,
        result.distance,
        result.durationValue,
        result.duration,
      );
      mapsStoreController.rideOptions.refresh();
      polylineCoordinates.clear();
      print(result.distance);
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}
