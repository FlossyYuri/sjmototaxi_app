import 'dart:async';

import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/model/RideOptions.dart';
import 'package:agotaxi/model/place.dart';
import 'package:agotaxi/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class MapsStoreController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  RxList<GoogleMapsPlace> googlePopularPlaces = <GoogleMapsPlace>[].obs;
  final box = GetStorage();
  RxList<String> rejectedRides = RxList<String>();
  var rideLastStatus = 'opened'.obs;
  var requestStep = 0.obs;
  var lastRideStatus = '-'.obs;
  var rideOptions = RideOptions.emptyRide().obs;

  void setRide(RideOptions ride) {
    rideOptions.value = ride;
    rideOptions.refresh();
  }

  void updateLastRideStatus(String status) {
    lastRideStatus.value = status;
    lastRideStatus.refresh();
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

  void changeRideStatus(String status) {
    _firestore
        .collection('rides')
        .doc(rideOptions.value.id)
        .update({'status': status});
  }

  void rateUser(String comment, int stars, UserModel user) {
    _firestore.collection('rates').add({
      'userId': user.uid,
      'userName': user.name,
      'userPhoto': user.photo,
      'stars': stars,
      'comment': comment,
      'date': FieldValue.serverTimestamp(),
      'rideID': rideOptions.value.id,
      'ratedBy': rideOptions.value.id,
    });
  }

  void closeTicket() {
    _firestore.collection('rides').doc(rideOptions.value.id).update({
      'status': 'closed',
      'createdAt': FieldValue.serverTimestamp(),
    });
    box.write('ratingMissing', true);
    print('closed');
  }

  void cleanRide() {
    box.remove('rideID');
    rejectedRides.value.clear();
    requestStep.value = 0;
    rideOptions.value = RideOptions.emptyRide();
    requestStep.refresh();
    rideOptions.refresh();
    rejectedRides.refresh();
    box.remove('ratingMissing');
  }

  void handleRejectedRides(String rideID) {
    rejectedRides.value.add(rideID);
    rejectedRides.refresh();
    box.write('rejectedRides', rejectedRides);
  }

  Future<void> initRide() async {
    var rideID = box.read('rideID');
    print('was i first ${rideID}');
    if (rideID != null) {
      var rideDcoument = await _firestore.collection('rides').doc(rideID).get();
      var rideMap = rideDcoument.data();
      if (rideMap != null) {
        RideOptions currentRide = RideOptions.fromMap(rideDcoument.data()!);
        if (currentRide.status != 'closed') {
          rideOptions.value = currentRide;
          rideOptions.refresh();
          requestStep.value = 4;
          requestStep.refresh();
          print('was i first');
          return;
        } else {
          if (box.read('ratingMissing')) {
            rideOptions.value = currentRide;
            rideOptions.refresh();
            Get.toNamed('/rate');
          }
        }
      }
      box.remove('rideID');
      // auth = (storedData as Map<String, dynamic>).obs;
    }
  }
}
