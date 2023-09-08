import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sjmototaxi_app/constants.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';
import 'package:sjmototaxi_app/widget/common/app_button.dart';

class RequestRide extends StatelessWidget {
  final ScrollController scrollController;
  RequestRide({super.key, required this.scrollController});

  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Obx(
          () {
            var veicle = veicleModels.firstWhere((element) =>
                element.type == mapsStoreController.rideOptions.value.type);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  color: Colors.grey.shade100,
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            width: 50,
                            child: SvgPicture.asset(
                              veicle.icon,
                              colorFilter: ColorFilter.mode(
                                Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  veicle.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  mapsStoreController
                                          .rideOptions.value.formatedDuration ??
                                      '...',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey.shade400,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '${mapsStoreController.rideOptions.value.price.toString()} MT',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: HexColor('#FCA311'),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: AppButton(
                      onClick: () {
                        mapsStoreController.nextStep();
                      },
                      label: "Solicitar"),
                ),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
