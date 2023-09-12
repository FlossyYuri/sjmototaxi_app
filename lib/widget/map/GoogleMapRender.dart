import 'package:agotaxi/constants.dart';
import 'package:agotaxi/model/Debouncer.dart';
import 'package:agotaxi/model/place.dart';
import 'package:agotaxi/services/auth.dart';
import 'package:agotaxi/services/maps.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/utils/location.dart';
import 'package:agotaxi/widget/map/MapSearchField.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapRender extends StatefulWidget {
  GoogleMapRender({super.key});

  @override
  State<GoogleMapRender> createState() => _GoogleMapRenderState();
}

class _GoogleMapRenderState extends State<GoogleMapRender> {
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());

  void driversCarPositionStream() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('online_drivers')
        .snapshots()) {
      _markers.clear();
      for (var driver in snapshot.docs) {
        Map<String, dynamic> data = driver.data();
        print(data['position']['latitude']);
        var marker = Marker(
            markerId: MarkerId(data['name']),
            icon: markerIcon['car'] ?? BitmapDescriptor.defaultMarker,
            position: LatLng(
              double.parse(data['position']['latitude']),
              double.parse(data['position']['longitude']),
            ),
            rotation: data['rotation'],
            anchor: Offset(0.5, 0.5));

        setState(() {
          _markers.add(marker);
        });
      }
    }
  }

  GoogleMapController? _controller;
  Future<void> onMapCreated(GoogleMapController controller) async {
    _controller = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    _controller!.setMapStyle(value);
  }

  final List<Marker> _markers = [];
  Map<String, BitmapDescriptor> markerIcon = {};
  _loadMarkerIcons() async {
    markerIcon['current'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/current_position.png');
    markerIcon['origin'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/origin.png');
    markerIcon['destinYellow'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/destin1.png');
    markerIcon['selected'] = await CustomLocationUtils()
        .getMarkerIconFromPng('assets/pngs/ic_pin.png');
    markerIcon['car'] =
        await CustomLocationUtils().getMarkerIconFromPng('assets/pngs/car.png');
    driversCarPositionStream();
  }

  LatLng currentPosition = const LatLng(-25.8858, 32.6129);
  LatLng? origin;
  LatLng? destin;

  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  String placeName = '';
  double currentPositionRotation = 0;
  final _debouncer = Debouncer(milliseconds: 300);

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
        origin = CustomLocationUtils().getLatLngFromPosition(value);
        if (_controller == null) return;
        CustomLocationUtils()
            .updateCameraPosition(_controller!, currentPosition);
      });
    });
  }

  void setPlaces() async {
    List<dynamic> popularPlaces = await getPlaces(currentPosition);
    List<GoogleMapsPlace> places = popularPlaces.map((place) {
      return GoogleMapsPlace(
        place['name'],
        place['place_id'],
        LatLng(place['geometry']['location']['lat'],
            place['geometry']['location']['lng']),
      );
    }).toList();
    mapsStoreController.setPlaces(places);
    mapsStoreController.googlePopularPlaces.refresh();
  }

  @override
  void initState() {
    _loadMarkerIcons();
    _setCurrentPosition();
    _liveLocation();
    setPlaces();
    super.initState();
  }

  bool _loading = false;

  void updatePlaceName() {
    _debouncer.run(() {
      performReverseGeocoding(destin!).then((name) {
        setState(() {
          placeName = name;
        });
        mapsStoreController.rideOptions.value.destiny =
            GoogleMapsPlace(name, null, destin!);
        mapsStoreController.rideOptions.refresh();
      });
    });
  }

  _setLoadingMenu(bool _status) {
    setState(() {
      _loading = _status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Obx(
        () => SizedBox(
          height: constraints.maxHeight / getLayoutSizeByStep(),
          child: Column(
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
                            onCameraMove: (position) {
                              if (mapsStoreController.requestStep.value == 1)
                                setState(() {
                                  destin = position.target;
                                  updatePlaceName();
                                });
                            },
                            onTap: mapsStoreController.requestStep.value == 1
                                ? (position) {
                                    setState(() {
                                      destin = position;
                                      updatePlaceName();
                                    });
                                  }
                                : null,
                            markers: {
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
                              if (destin != null)
                                Marker(
                                  markerId: MarkerId("selectedLocation"),
                                  icon: markerIcon['selected'] ??
                                      BitmapDescriptor.defaultMarker,
                                  position: LatLng(
                                    destin!.latitude,
                                    destin!.longitude,
                                  ),
                                ),
                              ..._markers
                            },
                          ),
                          if (mapsStoreController.requestStep.value == 1)
                            Positioned(
                              top: 90,
                              left: 0,
                              right: 0,
                              child: Container(
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 20,
                                      offset: Offset(0, 0),
                                      color: Colors.white.withAlpha(200),
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                child: Text(
                                  "Mova o mapa para trocar a localização",
                                  textAlign: TextAlign.center,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          if (placeName.isNotEmpty &&
                              mapsStoreController.requestStep.value == 1)
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 20,
                                        offset: Offset(0, -5),
                                        color: Colors.black.withAlpha(25),
                                      ),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        "Destino selecionado",
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium!
                                            .apply(color: Colors.grey.shade600),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        placeName,
                                        textAlign: TextAlign.left,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                    ],
                                  )),
                            ),
                          if (mapsStoreController.requestStep.value == 1)
                            MapSearchField(
                              callback: (coordinates, name) {
                                setState(() {
                                  destin = coordinates;
                                  CustomLocationUtils().updateCameraPosition(
                                      _controller!, coordinates);
                                  placeName = name;
                                });
                              },
                            ),
                        ],
                      ),
              ),
              mapsStoreController.requestStep.value == 1
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        InkWell(
                          onTap: () async {
                            if (origin != null && destin != null) {
                              mapsStoreController.rideOptions.value.destiny =
                                  GoogleMapsPlace(placeName, null, destin!);
                              mapsStoreController.rideOptions.refresh();
                              mapsStoreController.nextStep();
                              await _getPolyline();
                            }
                          },
                          child: Container(
                            color: Theme.of(context).primaryColor,
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 24),
                            child: Text(
                              'Aplicar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container()
            ],
          ),
        ),
      );
    });
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
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        GOOGLE_API_KEY,
        PointLatLng(origin!.latitude, origin!.longitude),
        PointLatLng(destin!.latitude, destin!.longitude),
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
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }

  double getLayoutSizeByStep() {
    switch (mapsStoreController.requestStep.value) {
      case 1:
        return 1;
      case 2:
        return 1.6;
      case 4:
        return 1.6;
      default:
        return 1.45;
    }
  }
}
