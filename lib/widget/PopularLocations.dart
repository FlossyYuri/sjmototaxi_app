import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:agotaxi/constants.dart';
import 'package:agotaxi/store/maps_store_controller.dart';

class PopularLocations extends StatelessWidget {
  PopularLocations({
    super.key,
  });

  final MapsStoreController mapsStoreController =
      Get.put(MapsStoreController());
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Localizações populares",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.grey.shade400,
              ),
            ),
            const SizedBox(height: 16),
            ...mapsStoreController.googlePopularPlaces.value
                .take(6)
                .map(
                  (e) => Column(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset('assets/icons/ic_pin.svg'),
                          const SizedBox(width: 12),
                          Text(
                            e.name,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontSize: 18),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Divider(thickness: 0.3)
                    ],
                  ),
                )
                .toList()
          ],
        ));
  }
}
