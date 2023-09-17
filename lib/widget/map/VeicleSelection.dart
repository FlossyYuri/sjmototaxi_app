import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/enums/RideTypes.dart';
import 'package:agotaxi/store/maps_store_controller.dart';

class VeicleSelectionScroll extends StatelessWidget {
  final ScrollController scrollController;
  VeicleSelectionScroll({super.key, required this.scrollController});
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 24,
                ),
                child: Center(
                  child: Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              ...veicleModels
                  .map((veicle) => VeicleSelection(
                        veicle: veicle.type,
                        name: veicle.name,
                        speed: veicle.speed,
                        icon: veicle.icon,
                        selected: mapsStoreController.rideOptions.value.type ==
                            veicle.type,
                        pricePerKm: veicle.pricePerKM,
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}

class VeicleSelection extends StatelessWidget {
  final String icon;
  final VeicleTypes veicle;
  final double speed;
  final double pricePerKm;
  final String name;
  final bool selected;
  VeicleSelection({
    super.key,
    required this.icon,
    required this.veicle,
    required this.name,
    required this.speed,
    required this.pricePerKm,
    this.selected = false,
  });

  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int distance = mapsStoreController.rideOptions.value.distance ?? 0;
      int duration = mapsStoreController.rideOptions.value.duration ?? 0;
      return InkWell(
        onTap: () {
          mapsStoreController.setVeicle(
              veicle,
              ((pricePerKm * distance) / 1000).ceil(),
              authStoreController.auth.value['user']);
          mapsStoreController.nextStep();
          // print(mapsStoreController.requestStep);
        },
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          color: selected ? Theme.of(context).primaryColor : Colors.white,
          child: Row(
            children: [
              Container(
                width: 50,
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    selected ? Colors.white : Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: selected ? Colors.white : Colors.black,
                        ),
                      ),
                      Text(
                        '${mapsStoreController.rideOptions.value.formatedDistance}',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: selected ? Colors.white : Colors.grey.shade400,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${((pricePerKm * distance) / 1000).ceil()} MT',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: selected ? Colors.white : Colors.black,
                    ),
                  ),
                  Text(
                    '${((duration * speed) / 60).ceil()} mins',
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: selected ? Colors.white : Colors.grey.shade400,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }
}
