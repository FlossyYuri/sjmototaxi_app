import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/enums/ButtonTypes.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/AdvancedLine.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/line.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchRideDriver extends StatelessWidget {
  WatchRideDriver({super.key});
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset(0, 5),
            color: Colors.black.withAlpha(50),
          ),
        ],
      ),
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  width: 1,
                  color: Colors.grey.shade200,
                ),
              ),
              color: Colors.grey.shade100,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundImage: Image.asset(
                        'assets/images/kfc.jpg',
                        fit: BoxFit.cover,
                      ).image,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Jamal Canan",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/star.svg',
                                height: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "4.9",
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade400,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    FloatingActionButton.small(
                      //<-- SEE HERE
                      backgroundColor: Theme.of(context).primaryColor,
                      heroTag: 'chatButton',
                      onPressed: () {
                        Navigator.pushNamed(context, '/chat');
                      },
                      elevation: 0,
                      highlightElevation: 2,
                      child: SvgPicture.asset(
                        'assets/icons/message.svg',
                        width: 24,
                        height: 24,
                      ),
                    ),
                    SizedBox(width: 8),
                    FloatingActionButton.small(
                      //<-- SEE HERE
                      heroTag: 'callButton',
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {
                        launchUrl(Uri.parse("tel://840521586"));
                      },
                      elevation: 0,
                      highlightElevation: 2,
                      child: SvgPicture.asset(
                        'assets/icons/contact.svg',
                        width: 24,
                        height: 24,
                        colorFilter: ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Row(
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
                Obx(
                  () => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          mapsStoreController.newRide.value.origin!.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 8),
                        Divider(
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 8),
                        Text(
                          mapsStoreController.newRide.value.destiny!.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () {
              var veicle = veicleModels.firstWhere((element) =>
                  element.type == mapsStoreController.newRide.value.type);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          veicle.icon,
                          colorFilter: ColorFilter.mode(
                            Colors.black,
                            BlendMode.srcIn,
                          ),
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'DISTÂNCIA',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapsStoreController
                                      .newRide.value.formatedDistance ??
                                  '...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Text(
                              'TEMPO',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapsStoreController
                                      .newRide.value.formatedDuration ??
                                  '...',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 32),
                        Column(
                          children: [
                            Text(
                              'PREÇO',
                              style: TextStyle(
                                color: Colors.grey.shade400,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${mapsStoreController.newRide.value.price ?? "..."} MT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Flexible(
                          child: AppButton(
                            onClick: () {},
                            type: ButtonTypes.outlined,
                            label: "Cancelar",
                          ),
                        ),
                        const SizedBox(width: 16),
                        Flexible(
                          child: AppButton(
                            onClick: () {},
                            label: "Aceitar",
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
