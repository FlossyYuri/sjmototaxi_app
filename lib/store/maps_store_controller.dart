import 'package:get/get.dart';
import 'package:sjmototaxi_app/model/RideOptions.dart';
import 'package:sjmototaxi_app/model/place.dart';

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
  ).obs;

  void setPlaces(List<GoogleMapsPlace> places) {
    googlePopularPlaces.value = places;
    googlePopularPlaces.refresh();
  }

  void nextStep() {
    requestStep.value++;
  }

  void previousStep() {
    requestStep.value--;
  }
}
