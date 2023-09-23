import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/enums/ButtonTypes.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/AdvancedLine.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/line.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class WatchRideDriver extends StatelessWidget {
  final Function subcribeToRide;
  WatchRideDriver({super.key, required this.subcribeToRide});
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
                    Obx(
                      () => CircleAvatar(
                        radius: 24,
                        backgroundImage: Image.asset(
                          mapsStoreController.rideOptions.value.client?.photo ??
                              'assets/pngs/userVector.png',
                          fit: BoxFit.cover,
                        ).image,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                        child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            mapsStoreController.rideOptions.value.client!.name,
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
                    )),
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
                        launchUrl(Uri.parse(
                            "tel://${mapsStoreController.rideOptions.value.client!.phone}"));
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
          const SizedBox(height: 8),
          Obx(
            () {
              var veicle = veicleModels.firstWhere((element) =>
                  element.type == mapsStoreController.rideOptions.value.type);
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
                                color: Colors.grey.shade400,
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
                                color: Colors.grey.shade400,
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
                  ],
                ),
              );
            },
          ),
          Divider(
            color: Colors.grey.shade200,
          ),
          const SizedBox(height: 4),
          if (['accepted', 'running']
              .contains(mapsStoreController.rideOptions.value.status))
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
          if (['ready', 'arrived-destin']
              .contains(mapsStoreController.rideOptions.value.status))
            Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButton(
                            onClick: () {
                              if (mapsStoreController
                                      .rideOptions.value.status ==
                                  'ready') {
                                mapsStoreController.changeRideStatus('running');
                              }
                              if (mapsStoreController
                                      .rideOptions.value.status ==
                                  'arrived-destin') {
                                Get.toNamed('/cart');
                                // mapsStoreController.changeRideStatus('closed');
                                // mapsStoreController.changeRideStatus('running');
                              }
                            },
                            label: getButtonText(
                                mapsStoreController.rideOptions.value.status),
                          ),
                        ],
                      ),
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
          if (mapsStoreController.rideOptions.value.status == 'opened')
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Flexible(
                    child: AppButton(
                      onClick: () async {
                        print(mapsStoreController.rideOptions.value.id);
                        print(authStoreController.auth['user']['uid']);
                        var document = await _firestore
                            .collection('rides')
                            .doc(mapsStoreController.rideOptions.value.id)
                            .update({
                          'rejectedDrivers': FieldValue.arrayUnion(
                              [authStoreController.auth['user']['uid']])
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Corrida rejeitada!'),
                          ),
                        );
                      },
                      type: ButtonTypes.outlined,
                      label: "Rejeitar",
                    ),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: AppButton(
                      onClick: () {
                        _firestore
                            .collection('rides')
                            .doc(mapsStoreController.rideOptions.value.id)
                            .update({
                          'status': 'accepted',
                          'driver': authStoreController.auth.value['user']
                        });
                        mapsStoreController.saveCurrentRide(
                            mapsStoreController.rideOptions.value.id!);
                        subcribeToRide();
                      },
                      label: "Aceitar",
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

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
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  // Handle Delete action
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String getButtonText(String status) {
    switch (status) {
      case 'ready':
        return 'Iniciar Corrida';
      case 'arrived-destin':
        return 'Finalizar';
      default:
        return 'Pendente';
    }
  }

  String getStatus(String status) {
    switch (status) {
      case 'accepted':
        return 'Vá até ao passageiro';
      case 'ready':
        return 'Iniciar Corrida';
      case 'running':
        return 'Leve o passageiro ao destino';
      case 'canceled':
        return 'Cancelado';
      case 'arrived-destin':
        return 'Finalizar';
      case 'closed':
        return 'Finalizado';
      default:
        return 'Pendente';
    }
  }
}
