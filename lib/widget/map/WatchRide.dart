import 'package:agotaxi/constants.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/AdvancedLine.dart';
import 'package:agotaxi/widget/line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchRide extends StatelessWidget {
  final ScrollController scrollController;
  WatchRide({super.key, required this.scrollController});
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  // Handle Edit action
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete, color: Colors.red.shade500),
                title: Text(
                  'Cancelar Corrida',
                  style: TextStyle(color: Colors.red.shade500),
                ),
                onTap: () {
                  // Handle Delete action
                  mapsStoreController.changeRideStatus('canceled');
                  mapsStoreController.cleanRide();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          topLeft: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 12),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
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
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Obx(
                        () => CircleAvatar(
                          radius: 24,
                          backgroundImage: Image.asset(
                            mapsStoreController
                                    .rideOptions.value.client?.photo ??
                                'assets/pngs/userVector.png',
                            fit: BoxFit.cover,
                          ).image,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              mapsStoreController
                                      .rideOptions.value.driver?.name ??
                                  "Driver",
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
                                  "...",
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
                          if (mapsStoreController.rideOptions.value.driver !=
                              null) {
                            launchUrl(Uri.parse(
                                "tel://${mapsStoreController.rideOptions.value.driver?.phone}"));
                          }
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
            const SizedBox(height: 16),
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
                      SvgPicture.asset(
                        'assets/icons/ic_pin.svg',
                        colorFilter: ColorFilter.mode(
                          HexColor('#F02659'),
                          BlendMode.srcIn,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Obx(
                    () => Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            mapsStoreController.rideOptions.value.origin!.name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(
                            color: Colors.grey.shade300,
                            height: 20,
                          ),
                          SizedBox(height: 8),
                          Text(
                            mapsStoreController.rideOptions.value.destin!.name,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Obx(
              () {
                print(mapsStoreController.rideOptions.value.type.toString());
                var veicle = veicleModels.firstWhere((element) =>
                    element.type.toString() ==
                    mapsStoreController.rideOptions.value.type.toString());
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
                    ],
                  ),
                );
              },
            ),
            Divider(
              color: Colors.grey.shade200,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (mapsStoreController.rideOptions.value.status ==
                            'opened')
                          SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              color: Theme.of(context).primaryColor,
                              strokeWidth: 2,
                              semanticsLabel: 'Searching',
                            ),
                          ),
                        const SizedBox(width: 16),
                        Obx(
                          () => Text(
                            getStatus(
                                mapsStoreController.rideOptions.value.status),
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _showOptions(context),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  String getStatus(String status) {
    switch (status) {
      case 'opened':
        return 'Buscando ...';
      case 'ready':
        return 'Va até o motorista';
      case 'accepted':
        return 'Aguarde pelo motorista';
      case 'running':
        return 'Em progresso';
      case 'canceled':
        return 'Cancelado';
      case 'closed':
        return 'Finalizado';
      default:
        return 'Pendente';
    }
  }
}
