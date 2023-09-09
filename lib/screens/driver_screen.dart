import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';
import 'package:sjmototaxi_app/widget/map/DriverGoogleMap.dart';
import 'package:sjmototaxi_app/widget/map/GoogleMapRender.dart';
import 'package:sjmototaxi_app/widget/map/RequestRide.dart';
import 'package:sjmototaxi_app/widget/map/RouteSelection.dart';
import 'package:sjmototaxi_app/widget/map/VeicleSelection.dart';
import 'package:sjmototaxi_app/widget/map/WatchRide.dart';
import 'package:sjmototaxi_app/widget/map/WatchRideDriver.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen>
    with TickerProviderStateMixin {
  int activeTabIndex = 0;
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());
  int step = 0;
  // void setGyroscopeListener() {
  //   gyroscopeEvents.listen(
  //     (GyroscopeEvent event) {
  //       // print(event.z);
  //     },
  //     onError: (error) {},
  //     cancelOnError: true,
  //   );
  // }

  @override
  void initState() {
    // setGyroscopeListener();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double maxSize = getMaxSnapSize();
    double minSize = getMinSnapSize();
    double initialSize = getInitialSnapSize();

    ever(mapsStoreController.requestStep, (_) {
      setState(() {
        step = mapsStoreController.requestStep.value;
      });
    });

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
              Positioned(
                bottom: 24,
                right: 24,
                left: 24,
                child: WatchRideDriver(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double getMaxSnapSize() {
    if (step == 0) return 0.9;
    if (step == 2) return 0.5;
    return 1;
  }

  double getMinSnapSize() {
    if (step == 0) return 0.3333;
    if (step == 1) return 0;
    if (step == 2) return 0.4;
    if (step == 3) return 0.3333;
    if (step == 4) return 0.4;
    return 0;
  }

  double getInitialSnapSize() {
    if (step == 0) return 0.3333;
    if (step == 1) return 0;
    if (step == 2) return 0.4;
    if (step == 3) return 0.3333;
    if (step == 4) return 0.4;
    return 0.3334;
  }
}
