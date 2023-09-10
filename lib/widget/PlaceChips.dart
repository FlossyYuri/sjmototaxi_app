import 'package:flutter/material.dart';
import 'package:agotaxi/model/place.dart';

class PlaceChips extends StatelessWidget {
  List<GoogleMapsPlace> places;
  PlaceChips({super.key, required this.places});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      clipBehavior: Clip.none,
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: places
            .take(6)
            .map(
              (place) => Container(
                margin: const EdgeInsets.only(right: 8),
                child: Chip(
                  label: Text(place.name),
                  backgroundColor: Colors.white,
                  elevation: 10,
                  shadowColor: Colors.black.withAlpha(120),
                  side: BorderSide(color: Colors.grey.shade200),
                  labelPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
