import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:sjmototaxi_app/store/maps_store_controller.dart';

class VeicleSelectionScroll extends StatelessWidget {
  final ScrollController scrollController;
  const VeicleSelectionScroll({super.key, required this.scrollController});

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
        child: Column(
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
            const SizedBox(height: 16),
            Container(
              height: 12,
              color: Colors.grey.shade200,
            ),
            const SizedBox(height: 16),
            VeicleSelection(
              veicle: 'Carro',
              icon: 'assets/icons/car-black-side-silhouette.svg',
              distance: 'Proximo de mim',
              price: '250MT',
            ),
            VeicleSelection(
              veicle: 'Motorizada',
              icon: 'assets/icons/single-motorbike.svg',
              distance: '2 min',
              selected: 'Motorizada',
              price: '250MT',
            ),
            VeicleSelection(
              veicle: 'Txopela',
              icon: 'assets/icons/txopela.svg',
              distance: '3 min',
              price: '250MT',
            ),
          ],
        ),
      ),
    );
  }
}

class VeicleSelection extends StatelessWidget {
  final String icon;
  final String veicle;
  final String distance;
  final String price;
  final String? selected;
  VeicleSelection({
    super.key,
    required this.icon,
    required this.veicle,
    required this.distance,
    required this.price,
    this.selected,
  });

  final MapsStoreController mapsStoreController =
      Get.find<MapsStoreController>();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        mapsStoreController.nextStep();
        // print(mapsStoreController.requestStep);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
        ),
        color: selected != null && selected == veicle
            ? Theme.of(context).primaryColor
            : Colors.white,
        child: Row(
          children: [
            Container(
              width: 50,
              child: SvgPicture.asset(
                icon,
                colorFilter: ColorFilter.mode(
                  selected != null && selected == veicle
                      ? Colors.white
                      : Colors.black,
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
                      veicle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: selected != null && selected == veicle
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    Text(
                      distance,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: selected != null && selected == veicle
                            ? Colors.white
                            : Colors.grey.shade400,
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
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: selected != null && selected == veicle
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
                // Text(
                //   "X",
                //   style: TextStyle(
                //     fontWeight: FontWeight.normal,
                //     color: Colors.grey.shade400,
                //     fontSize: 18,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
