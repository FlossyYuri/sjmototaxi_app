import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/common/app_button.dart';

class RequestRide extends StatelessWidget {
  final ScrollController scrollController;
  final Function subcribeToRide;
  RequestRide(
      {super.key,
      required this.scrollController,
      required this.subcribeToRide});

  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppButton(
                            onClick: () async {
                              var x =
                                  mapsStoreController.rideOptions.value.toMap();
                              var ride =
                                  await _firestore.collection('rides').add(x);
                              ride.update({
                                'id': ride.id,
                                'createdAt': FieldValue.serverTimestamp(),
                              });
                              mapsStoreController.saveCurrentRide(ride.id);
                              subcribeToRide();
                              mapsStoreController.nextStep();
                            },
                            label: "Solicitar"),
                      ],
                    )),
                const SizedBox(height: 32),
              ],
            );
          },
        ),
      ),
    );
  }
}
