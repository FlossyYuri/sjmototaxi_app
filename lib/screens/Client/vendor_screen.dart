import 'package:agotaxi/widget/vendor/CatalogueItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int activeCategoryIndex = 0;
  final List<String> categories = ["Streetwise", "Wraps", "Burgers"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 6);
    _tabController.addListener(() {
      setState(() {
        activeCategoryIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F2F2F2"),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.asset('assets/images/banner.png', fit: BoxFit.cover),
            Expanded(
              child: Transform.translate(
                offset: const Offset(0.0, -24.0),
                child: Container(
                  padding: const EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    color: HexColor('#F2F2F2'),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "KFC",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Frango Panado - Batata",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset('assets/icons/star.svg'),
                                const SizedBox(width: 8),
                                const Text(
                                  "4.0 (2 REVIEWS)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "15 min de espera",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            top: 24,
                            bottom: 24,
                          ),
                          padding: const EdgeInsets.only(
                            left: 24,
                            top: 8,
                            bottom: 8,
                          ),
                          decoration: BoxDecoration(
                            color: HexColor("#FF6339").withAlpha(100),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(
                                20,
                              ),
                              bottomLeft: Radius.circular(
                                20,
                              ),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Row(
                              children: categories
                                  .map(
                                    (category) => Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 24),
                                      child: Text(
                                        category,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: activeCategoryIndex == 0
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                        const CatalogueItem(),
                        const SizedBox(height: 12),
                        const CatalogueItem(),
                        const SizedBox(height: 12),
                        const CatalogueItem(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
