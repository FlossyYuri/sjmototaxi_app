import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';
import 'package:sjmototaxi_app/widget/map/GoogleMapRender.dart';
import 'package:sjmototaxi_app/widget/map/RequestRide.dart';
import 'package:sjmototaxi_app/widget/map/RouteSelection.dart';
import 'package:sjmototaxi_app/widget/map/VeicleSelection.dart';
import 'package:sjmototaxi_app/widget/map/WatchRide.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
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

    ever(mapsStoreController.requestStep, (_) {
      setState(() {
        step = mapsStoreController.requestStep.value;
      });
    });

    return Scaffold(
      backgroundColor: HexColor("#F2F2F2"),
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Stack(
          children: [
            GoogleMapRender(
              step: step,
            ),
            DraggableScrollableSheet(
              initialChildSize: step != 1 || step != 3 ? 0.3333 : 0,
              minChildSize: step != 1 || step != 3 ? 0.3333 : 0,
              maxChildSize: maxSize,
              snap: step != 1,
              snapSizes: [0.3333, maxSize],
              builder:
                  (BuildContext context, ScrollController scrollController) {
                switch (step) {
                  case 0:
                    return RouteSelection(scrollController: scrollController);
                  case 1:
                    return Container();
                  case 2:
                    return VeicleSelectionScroll(
                        scrollController: scrollController);
                  case 3:
                    return RequestRide(scrollController: scrollController);
                  default:
                    return WatchRide(scrollController: scrollController);
                }
              },
            )
          ],
        ),
      ),
    );
  }

  double getMaxSnapSize() {
    if (step == 0) return 0.9;
    if (step == 2) return 0.4;
    return 0.3334;
  }
}
