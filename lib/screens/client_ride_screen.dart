import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/map/GoogleMapRender.dart';
import 'package:agotaxi/widget/map/RequestRide.dart';
import 'package:agotaxi/widget/map/RouteSelection.dart';
import 'package:agotaxi/widget/map/VeicleSelection.dart';
import 'package:agotaxi/widget/map/WatchRide.dart';

class ClientRideScreen extends StatefulWidget {
  const ClientRideScreen({super.key});

  @override
  State<ClientRideScreen> createState() => _ClientRideScreenState();
}

class _ClientRideScreenState extends State<ClientRideScreen>
    with TickerProviderStateMixin {
  int activeTabIndex = 0;
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  // void setGyroscopeListener() {
  //   gyroscopeEvents.listen(
  //     (GyroscopeEvent event) {
  //       // print(event.z);
  //     },
  //     onError: (error) {},
  //     cancelOnError: true,
  //   );
  // }
  void driversCarPositionStream() async {
    await for (var snapshot in FirebaseFirestore.instance
        .collection('rides')
        .doc(mapsStoreController.rideOptions.value.id)
        .snapshots()) {
      print(snapshot.data()?['status']);
      print(snapshot.data()?['driver']);
    }
  }

  @override
  void initState() {
    // setGyroscopeListener();

    super.initState();
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
              GoogleMapRender(),
              Obx(
                () {
                  double maxSize =
                      getMaxSnapSize(mapsStoreController.requestStep.value);
                  double minSize =
                      getMinSnapSize(mapsStoreController.requestStep.value);
                  double initialSize =
                      getInitialSnapSize(mapsStoreController.requestStep.value);
                  return DraggableScrollableSheet(
                    initialChildSize: initialSize,
                    minChildSize: minSize,
                    maxChildSize: maxSize,
                    snap: mapsStoreController.requestStep.value != 1,
                    snapSizes: Set.of([minSize, initialSize, maxSize]).toList(),
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      switch (mapsStoreController.requestStep.value) {
                        case 0:
                          return RouteSelection(
                              scrollController: scrollController);
                        case 1:
                          return Container();
                        case 2:
                          return VeicleSelectionScroll(
                              scrollController: scrollController);
                        case 3:
                          return RequestRide(
                              scrollController: scrollController);
                        default:
                          return WatchRide(scrollController: scrollController);
                      }
                    },
                  );
                },
              ),
              Positioned(
                top: 100,
                right: 20,
                child: TextButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red)),
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

  double getMaxSnapSize(int step) {
    if (step == 0) return 0.9;
    if (step == 2) return 0.5;
    return 1;
  }

  double getMinSnapSize(int step) {
    if (step == 0) return 0.3333;
    if (step == 1) return 0;
    if (step == 2) return 0.4;
    if (step == 3) return 0.3333;
    if (step == 4) return 0.4;
    return 0;
  }

  double getInitialSnapSize(int step) {
    if (step == 0) return 0.3333;
    if (step == 1) return 0;
    if (step == 2) return 0.4;
    if (step == 3) return 0.3333;
    if (step == 4) return 0.4;
    return 0.3334;
  }
}
