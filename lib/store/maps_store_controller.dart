import 'dart:async';

import 'package:agotaxi/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/RideOptions.dart';
import 'package:agotaxi/model/place.dart';

class MapsStoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<GoogleMapsPlace> googlePopularPlaces = <GoogleMapsPlace>[].obs;
  final box = GetStorage();
  late StreamSubscription _currentRideSubscription;
  RxList<String> rejectedRides = RxList<String>();
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
    'opened',
  ).obs;

  void setRide(RideOptions ride) {
    rideOptions.value = ride;
    rideOptions.refresh();
  }

  void saveCurrentRide(String documentId) {
    rideOptions.value.id = documentId;
    box.write('rideID', documentId);
  }

  void setVeicle(VeicleTypes veicle, int price, Map<String, dynamic> user) {
    rideOptions.value.type = veicle;
    rideOptions.value.price = price;
    rideOptions.value.client = UserModel.fromMap(user);
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

  void handleRejectedRides(String rideID) {
    rejectedRides.value.add(rideID);
    rejectedRides.refresh();
    box.write('rejectedRides', rejectedRides);
  }

  Future<void> initRide() async {
    var rideID = box.read('rideID');
    if (rideID != null) {
      var rideDcoument = await _firestore.collection('rides').doc(rideID).get();
      var rideMap = rideDcoument.data();
      if (rideMap != null) {
        RideOptions currentRide = RideOptions.fromMap(rideDcoument.data()!);
        if (currentRide.status != 'closed') {
          rideOptions.value = currentRide;
          rideOptions.refresh();
          print('was i first');
          return;
        }
      }

      box.remove('rideID');
      // auth = (storedData as Map<String, dynamic>).obs;
    }
  }
}
