import 'package:agotaxi/store/maps_store_controller.dart';
import 'package:agotaxi/widget/checkout/PaymentMethods.dart';
import 'package:agotaxi/widget/common/app_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  int varQuant = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F5F5F8"),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: HexColor("#F5F5F8"),
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: const Text(
          'Finalizar corrida',
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Text(
              'Solicite o pagamento ao cliente.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Distância"),
                Obx(
                  () => Text(
                    mapsStoreController.rideOptions.value.formatedDistance ??
                        '...',
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Tempo total"),
                Obx(
                  () => Text(
                    mapsStoreController.rideOptions.value.formatedDuration ??
                        '...',
                  ),
                )
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor),
                ),
                Text(
                  '${mapsStoreController.rideOptions.value.price ?? "..."} MT',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor),
                )
              ],
            ),
            const Divider(),
            const SizedBox(height: 24),
            const PaymentMethods(),
            const SizedBox(
              height: 16,
            ),
            AppButton(
                onClick: () {
                  mapsStoreController.closeTicket();
                  Get.toNamed('/rate');
                },
                label: 'Confirmar pagamento'),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
