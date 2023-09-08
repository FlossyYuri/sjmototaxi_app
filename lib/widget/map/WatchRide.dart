import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sjmototaxi_app/screens/Common/chat_screen.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';
import 'package:sjmototaxi_app/utils/index.dart';
import 'package:sjmototaxi_app/widget/common/app_button.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchRide extends StatelessWidget {
  final ScrollController scrollController;
  WatchRide({super.key, required this.scrollController});
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
                              "Jamal Canana",
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
                      FloatingActionButton(
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
                        ),
                      ),
                      SizedBox(width: 16),
                      FloatingActionButton(
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
            const SizedBox(height: 32),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SvgPicture.asset(
                          'assets/icons/car-black-side-silhouette.svg',
                        ),
                        Spacer(),
                        Column(
                          children: [
                            Text(
                              'DISTÂNCIA',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapsStoreController
                                      .rideOptions.value.formatedDistance ??
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
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              mapsStoreController
                                      .rideOptions.value.formatedDuration ??
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
                                color: Colors.grey.shade300,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${mapsStoreController.rideOptions.value.price ?? "..."} MT',
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
                    AppButton(
                      onClick: () {
                        CustomUtils().showCustomDialog(context);
                      },
                      label: "Confirmar",
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
