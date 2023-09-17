import 'dart:async';

import 'package:agotaxi/model/RideOptions.dart';
import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/common/LoadingBar.dart';
import 'package:agotaxi/widget/map/DriverGoogleMap.dart';
import 'package:agotaxi/widget/map/WatchRideDriver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen>
    with WidgetsBindingObserver {
  int activeTabIndex = 0;
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  StreamSubscription? _availableRidesSubscription;
  StreamSubscription? _currentRideSubscription;
  // void setGyroscopeListener() {
  //   gyroscopeEvents.listen(
  //     (GyroscopeEvent event) {
  //       // print(event.z);
  //     },
  //     onError: (error) {},
  //     cancelOnError: true,
  //   );
  // }

  void ridesStream() async {
    var ridesStream = FirebaseFirestore.instance
        .collection('rides')
        .where('status', isEqualTo: 'opened')
        .where(
          'rejectedDrivers',
        )
        .snapshots();

    _availableRidesSubscription = ridesStream.listen((snapshot) {
      for (var document in snapshot.docs) {
        var ride = RideOptions.fromMap(document.data());
        if (!ride.rejectedDrivers!
            .contains(authStoreController.auth['user']['uid'])) {
          mapsStoreController.setRide(ride);
          break;
        }
      }
    });
  }

  void currentRideStream() async {
    print(mapsStoreController.rideOptions.value.id);
    var currentRidesStream = FirebaseFirestore.instance
        .collection('rides')
        .doc(mapsStoreController.rideOptions.value.id)
        .snapshots();

    _currentRideSubscription = currentRidesStream.listen((document) {
      print('Inside ${mapsStoreController.rideOptions.value.id}');
      var ride = RideOptions.fromMap(document.data()!);
      mapsStoreController.setRide(ride);
    });
  }

  void startSingleRideStream() {
    if (_availableRidesSubscription != null) {
      _availableRidesSubscription!.cancel();
    }
    if (_currentRideSubscription != null) {
      _currentRideSubscription!.cancel();
    }
    currentRideStream();
  }

  @override
  void initState() {
    // setGyroscopeListener();
    super.initState();
    print(mapsStoreController.rideOptions.value.toString());
    if (mapsStoreController.rideOptions.value.id != null) {
      print('found ${mapsStoreController.rideOptions.value.id}');
      currentRideStream();
    } else {
      print('Not ${mapsStoreController.rideOptions.value.id}');
      ridesStream();
    }
    WidgetsBinding.instance!.addObserver(this);
  }

  void deleteDocumentWithPosition() {
    String userId = _auth.currentUser!.uid;
    _firestore.collection('online_drivers').doc(userId).delete();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    if (_availableRidesSubscription != null) {
      _availableRidesSubscription!.cancel();
    }
    if (_currentRideSubscription != null) {
      _currentRideSubscription!.cancel();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) {
      // App is being closed
      print("CloseSX_______________");
      deleteDocumentWithPosition();
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        mapsStoreController.previousStep();
        return false;
      },
      child: Scaffold(
        backgroundColor: HexColor("#F2F2F2"),
        body: Container(
          color: Theme.of(context).primaryColor,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                top: 0,
                child: DriverGoogleMap(),
              ),
              Obx(() {
                if (mapsStoreController.rideOptions.value.client == null)
                  return Positioned(
                    bottom: 24,
                    right: 24,
                    left: 24,
                    child: LoadingBar(),
                  );
                return Positioned(
                  bottom: 24,
                  right: 24,
                  left: 24,
                  child: WatchRideDriver(
                    subcribeToRide: startSingleRideStream,
                  ),
                );
              }),
              Positioned(
                top: 30,
                right: 20,
                child: TextButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.red),
                  ),
                  onPressed: authStoreController.logout,
                  child: Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
