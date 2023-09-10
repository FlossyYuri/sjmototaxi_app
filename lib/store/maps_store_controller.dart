import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/RideOptions.dart';
import 'package:agotaxi/model/place.dart';

class MapsStoreController extends GetxController {
  RxList<GoogleMapsPlace> googlePopularPlaces = <GoogleMapsPlace>[].obs;
  var requestStep = 0.obs;
  var rideOptions = RideOptions(
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
  ).obs;
  var newRide = RideOptions(
    GoogleMapsPlace('Jimmy Mahotas', null, LatLng(-25.8879, 32.6037)),
    GoogleMapsPlace('Alameda do Aeroporto', null, LatLng(-25.9262, 32.5758)),
    VeicleTypes.car,
    null,
    2200,
    null,
    300,
    '2 km',
    '5 min',
    250,
  ).obs;

  void setVeicle(VeicleTypes veicle, int price) {
    rideOptions.value.type = veicle;
    rideOptions.value.price = price;
    rideOptions.refresh();
  }

  void setPlaces(List<GoogleMapsPlace> places) {
    googlePopularPlaces.value = places;
    googlePopularPlaces.refresh();
  }

  void nextStep() {
    if (requestStep.value < 5) requestStep.value++;
  }

  void previousStep() {
    if (requestStep.value > 0) requestStep.value--;
  }
}
