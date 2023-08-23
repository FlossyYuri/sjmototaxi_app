import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map_polyline_new/google_map_polyline_new.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sjmototaxi_app/constants.dart';
import 'package:sjmototaxi_app/model/place.dart';
import 'package:sjmototaxi_app/services/auth.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';
import 'package:sjmototaxi_app/utils/location.dart';
import 'package:sjmototaxi_app/widget/map/MapSearchField.dart';

class GoogleMapRender extends StatefulWidget {
  final int step;
  GoogleMapRender({super.key, this.step = 0});

  @override
  State<GoogleMapRender> createState() => _GoogleMapRenderState();
}

class _GoogleMapRenderState extends State<GoogleMapRender> {
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

  BitmapDescriptor selectedLocationIcon = BitmapDescriptor.defaultMarker;

  void setSelectedMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pngs/ic_pin.png")
        .then((icon) {
      selectedLocationIcon = icon;
    });
  }

  LatLng currentPosition = const LatLng(-25.8858, 32.6129);
  LatLng? origin;
  LatLng destin = const LatLng(-25.9327, 32.6040);
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
    setCurrentMarkerIcon();
    setSelectedMarkerIcon();
    _setCurrentPosition();
    _liveLocation();
    setPlaces();
    super.initState();
  }

  int _polylineCount = 1;
  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  GoogleMapPolyline _googleMapPolyline =
      new GoogleMapPolyline(apiKey: GOOGLE_API_KEY);
  bool _loading = false;

  //Polyline patterns
  List<List<PatternItem>> patterns = <List<PatternItem>>[
    <PatternItem>[], //line
    <PatternItem>[PatternItem.dash(30.0), PatternItem.gap(20.0)], //dash
    <PatternItem>[PatternItem.dot, PatternItem.gap(10.0)], //dot
    <PatternItem>[
      //dash-dot
      PatternItem.dash(30.0),
      PatternItem.gap(20.0),
      PatternItem.dot,
      PatternItem.gap(20.0)
    ],
  ];

  //Get polyline with Location (latitude and longitude)
  _getPolylinesWithLocation() async {
    _setLoadingMenu(true);
    List<LatLng>? _coordinates =
        await _googleMapPolyline.getCoordinatesWithLocation(
            origin: origin!, destination: destin, mode: RouteMode.driving);

    setState(() {
      _polylines.clear();
    });
    _addPolyline(_coordinates);
    _setLoadingMenu(false);
  }

  _addPolyline(List<LatLng>? _coordinates) {
    PolylineId id = PolylineId("poly$_polylineCount");
    Polyline polyline = Polyline(
        polylineId: id,
        patterns: patterns[0],
        color: Colors.blueAccent,
        points: _coordinates!,
        width: 10,
        onTap: () {});

    setState(() {
      _polylines[id] = polyline;
      _polylineCount++;
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
      return SizedBox(
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
                            polylines: Set<Polyline>.of(_polylines.values),
                            onTap: (position) {
                              print(position.toString());
                              setState(() {
                                origin = position;
                              });
                            },
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
                              if (origin != null)
                                Marker(
                                  markerId: MarkerId("selectedLocation"),
                                  icon: selectedLocationIcon,
                                  position: LatLng(
                                    origin!.latitude,
                                    origin!.longitude,
                                  ),
                                ),
                            },
                          ),
                          MapSearchField()
                        ],
                      ),
              ),
              widget.step == 1
                  ? Container(
                      color: Theme.of(context).primaryColor,
                      child: InkWell(
                        onTap: () {
                          mapsStoreController.nextStep();
                          print(mapsStoreController.requestStep);
                        },
                        child: Padding(
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
                    )
                  : Container()
            ],
          ));
    });
  }

  void drawPolyline() async {
    var response = http.post(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?key=' +
            GOOGLE_API_KEY +
            '&units=metric&origin=' +
            origin!.latitude.toString() +
            ',' +
            origin!.longitude.toString() +
            '&destination=' +
            destin.latitude.toString() +
            ',' +
            destin.longitude.toString() +
            '&mode=driving'));
  }

  double getLayoutSizeByStep() {
    switch (widget.step) {
      case 1:
        return 1;
      default:
        return 1.45;
    }
  }
}
