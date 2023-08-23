import 'package:sjmototaxi_app/widget/auth/create_account_tab.dart';
import 'package:sjmototaxi_app/widget/auth/login_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int activeTabIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _tabController.addListener(() {
      setState(() {
        activeTabIndex = _tabController.index;
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
    final bannerSize = 1 -
        (MediaQuery.of(context).size.height - 250) /
            MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              color: Theme.of(context).primaryColor,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned(
                    top: 32,
                    child: Image.asset(
                      'assets/ergox.png',
                      height: 150,
                    ),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 50),
                      Container(
                        clipBehavior: Clip.none,
                        height: 200,
                        width: 700,
                        child: SvgPicture.asset(
                          'assets/buildings.svg',
                          width: 700,
                          height: 250,
                          fit: BoxFit.cover,
                          alignment: Alignment.topCenter,
                          allowDrawingOutsideViewBox: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            activeTabIndex == 0
                ? LoginTab(
                    tabController: _tabController,
                    activeTabIndex: activeTabIndex,
                  )
                : CreateAccountTab(
                    tabController: _tabController,
                    activeTabIndex: activeTabIndex,
                  ),
          ]),
        ),
      ),
    );
  }
}
