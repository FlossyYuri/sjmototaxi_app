import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/AdvancedLine.dart';
import 'package:agotaxi/widget/PlaceChips.dart';
import 'package:agotaxi/widget/PopularLocations.dart';
import 'package:agotaxi/widget/line.dart';

class RouteSelection extends StatelessWidget {
  final ScrollController scrollController;
  RouteSelection({super.key, required this.scrollController});
  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 5),
            color: Colors.black.withAlpha(50),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12),
      child: SingleChildScrollView(
        controller: scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          SvgPicture.asset('assets/icons/ic_current.svg'),
                          Container(
                            height: 40,
                            alignment: Alignment.center,
                            child: AdvancedLine(
                              direction: Axis.vertical,
                              line: DashedLine(dashSize: 2, gapSize: 6),
                              paintDef: Paint()
                                ..strokeWidth = 3.0
                                ..strokeCap = StrokeCap.round,
                            ),
                          ),
                          SvgPicture.asset('assets/icons/ic_pin.svg'),
                        ],
                      ),
                      SizedBox(width: 16),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.all(0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  "PONTO DE PARTIDA",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Minha localização atual",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(fontSize: 18),
                                )
                              ],
                            ),
                          ),
                          Divider(
                            color: Colors.grey.shade300,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  mapsStoreController.nextStep();
                                  print(mapsStoreController.requestStep);
                                },
                                child: Row(children: [
                                  SvgPicture.asset('assets/icons/ic_map.svg'),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Escolha o destino",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 24,
                                        ),
                                      ),
                                      // Text(
                                      //   "KFC, Guerra popular",
                                      //   style: Theme.of(context)
                                      //       .textTheme
                                      //       .bodySmall!
                                      //       .copyWith(fontSize: 18),
                                      // ),
                                    ],
                                  ),
                                ]),
                              ),
                              Spacer(),
                              Container(
                                width: 1,
                                height: 32,
                                color: Colors.grey.shade300,
                                margin: EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                              ),
                              SvgPicture.asset(
                                'assets/icons/icon-close-alt.svg',
                                height: 24,
                                width: 24,
                              ),
                            ],
                          ),
                        ],
                      ))
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () => PlaceChips(
                places: mapsStoreController.googlePopularPlaces.value,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 12,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),
            PopularLocations(),
          ],
        ),
      ),
    );
  }
}
