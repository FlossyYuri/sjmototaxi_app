import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class RatesPercentage extends StatelessWidget {
  const RatesPercentage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('5'),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    height: 24,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  FractionallySizedBox(
                    widthFactor: 0.9,
                    child: Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: HexColor('#FFCC00'),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text('80%'),
          ],
        )
      ],
    );
  }
}
