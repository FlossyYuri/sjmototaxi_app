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
              GoogleMapRender(),
              DraggableScrollableSheet(
                initialChildSize: initialSize,
                minChildSize: minSize,
                maxChildSize: maxSize,
                snap: step != 1,
                snapSizes: Set.of([minSize, initialSize, maxSize]).toList(),
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
