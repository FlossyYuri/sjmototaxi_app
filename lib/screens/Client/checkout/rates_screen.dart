import 'package:sjmototaxi_app/widget/checkout/RatesPercentage.dart';
import 'package:sjmototaxi_app/widget/checkout/SingleRate.dart';
import 'package:sjmototaxi_app/widget/layout/SimpleAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class RatesScreen extends StatefulWidget {
  const RatesScreen({super.key});

  @override
  State<RatesScreen> createState() => _RatesScreenState();
}

class _RatesScreenState extends State<RatesScreen> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).canvasColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).canvasColor,
          appBar: const SimpleAppBar(
            title: 'Avaliações',
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 48,
                ),
                Text(
                  'Avaliações do clientes',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.grey.shade300,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/star2.svg', height: 24),
                      const SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/star2.svg', height: 24),
                      const SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/star2.svg', height: 24),
                      const SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/star2.svg', height: 24),
                      const SizedBox(width: 4),
                      SvgPicture.asset('assets/icons/star2.svg', height: 24),
                      const Spacer(),
                      Text(
                        "4.0 de 5",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                const Center(
                  child: Text("Foram feitas 2 avaliações"),
                ),
                const SizedBox(height: 24),
                const RatesPercentage(),
                const SizedBox(height: 12),
                const RatesPercentage(),
                const SizedBox(height: 12),
                const RatesPercentage(),
                const SizedBox(height: 12),
                const RatesPercentage(),
                const SizedBox(height: 12),
                const RatesPercentage(),
                const SizedBox(height: 24),
                ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: const [
                    SingleRate(),
                    SizedBox(height: 16),
                    SingleRate(),
                    SizedBox(height: 16),
                    SingleRate(),
                  ],
                ),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
