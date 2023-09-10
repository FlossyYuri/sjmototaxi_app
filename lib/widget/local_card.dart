import 'package:agotaxi/model/place.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LocalCardView extends StatelessWidget {
  const LocalCardView(
      {Key? key,
      required this.place,
      this.imageAlignment = Alignment.bottomCenter,
      this.onTap})
      : super(key: key);

  final GoogleMapsPlace place;
  final Alignment imageAlignment;
  final Function(String)? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Container(
          height: 140,
          padding: EdgeInsets.all(8),
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
            child: Image.asset(
              "assets/images/kfc.jpg",
              alignment: imageAlignment,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text(
              'KFC',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              '${place.name}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: TextStyle(
                color: Colors.grey.shade500,
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                SvgPicture.asset('assets/icons/star.svg'),
                const SizedBox(
                  width: 8,
                ),
                const Text(
                  "4.0 (2)",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ]),
        )
      ]),
    );
  }
}
