import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SingleRate extends StatelessWidget {
  const SingleRate({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: Image.asset(
              'assets/images/kfc.jpg',
              fit: BoxFit.cover,
            ).image,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nathan Manico",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    "18 de março de 2023",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    "Tudo show de bola \nasdasd Tudo show de bola Tudo show de bola",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset('assets/icons/star.svg'),
              Text(
                '4.0',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(
                width: 8,
              )
            ],
          )
        ],
      ),
    );
  }
}
