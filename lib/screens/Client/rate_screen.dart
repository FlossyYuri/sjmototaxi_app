import 'package:agotaxi/store/auth_store_controller.dart';
import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/layout/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class RateScreen extends StatefulWidget {
  const RateScreen({super.key});

  @override
  State<RateScreen> createState() => _RateScreenState();
}

class _RateScreenState extends State<RateScreen> {
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  final AuthStoreController authStoreController =
      Get.find<AuthStoreController>();
  int selectedRating = 0;
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const SimpleAppBar(
            title: 'Avaliar Motorista',
            isDark: false,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 48,
                ),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 68),
                          Obx(
                            () => Text(
                              mapsStoreController
                                      .rideOptions.value.driver?.name ??
                                  'Motorista',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleSmall,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Text(
                              '${mapsStoreController.rideOptions.value.driver?.brand ?? "-"} - ${mapsStoreController.rideOptions.value.driver?.plate ?? "-"}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "O que achou do \nproduto desta loja?",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Seu feedback irá ajudar a melhorar \nos serviços e produtos na aplicação.",
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [1, 2, 3, 4, 5].map((e) {
                              int index = e - 1;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedRating = e;
                                  });
                                },
                                child: SvgPicture.asset(
                                  index < selectedRating
                                      ? 'assets/icons/star2.svg'
                                      : 'assets/icons/star1.svg',
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 48),
                          TextField(
                            maxLines: 4, // Allows multiple lines
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(color: Colors.grey.shade400),
                            controller: _textController,
                            decoration: InputDecoration(
                              hintText: 'Comentário',
                              hintStyle: Theme.of(context).textTheme.bodySmall,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (selectedRating == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content:
                                              Text('Avaliação é obrigatória.'),
                                        ),
                                      );
                                      return;
                                    }
                                    switch (authStoreController.userRole()) {
                                      case 'DRIVER':
                                        mapsStoreController.rateUser(
                                            _textController.text,
                                            selectedRating,
                                            mapsStoreController
                                                .rideOptions.value.client!);
                                        break;
                                      default:
                                        mapsStoreController.rateUser(
                                            _textController.text,
                                            selectedRating,
                                            mapsStoreController
                                                .rideOptions.value.driver!);
                                    }

                                    mapsStoreController.cleanRide();
                                    Navigator.pushNamed(context, '/home');
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      borderRadius: BorderRadius.circular(
                                        8,
                                      ),
                                    ),
                                    child: const Text(
                                      "Enviar avaliação",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                    Positioned(
                        top: -50,
                        left: 0,
                        right: 0,
                        child: Obx(
                          () => CircleAvatar(
                            radius: 50,
                            backgroundImage: Image.asset(
                              mapsStoreController
                                      .rideOptions.value.driver?.photo ??
                                  'assets/pngs/userVector.png',
                              fit: BoxFit.contain,
                            ).image,
                          ),
                        )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
