import 'package:get/get.dart';
import 'package:sjmototaxi_app/enums/RideTypes.dart';
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
    null,
    null,
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
