import 'package:agotaxi/widget/common/app_button.dart';
import 'package:agotaxi/widget/forms/create_account_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:url_launcher/url_launcher.dart';

class CreateAccountTab extends StatefulWidget {
  final TabController _tabController;
  final int activeTabIndex;
  const CreateAccountTab({
    super.key,
    required TabController tabController,
    required this.activeTabIndex,
  }) : _tabController = tabController;
  @override
  State<CreateAccountTab> createState() => _CreateAccountTabState();
}

class _CreateAccountTabState extends State<CreateAccountTab>
    with TickerProviderStateMixin {
  late TabController _tab2Controller;
  int activeTab2Index = 0;

  @override
  void initState() {
    super.initState();
    _tab2Controller = TabController(vsync: this, length: 2);
    _tab2Controller.addListener(() {
      setState(() {
        activeTab2Index = _tab2Controller.index;
      });
    });
  }

  @override
  void dispose() {
    _tab2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
            onTap: () {
              widget._tabController.animateTo(0);
            },
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(12),
                  child: SvgPicture.asset(
                    'assets/icons/arrow-left.svg',
                    colorFilter: ColorFilter.mode(
                      Theme.of(context).primaryColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                Text(
                  "Voltar",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 00),
        Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 20,
                      offset: Offset(0, -5),
                      color: Colors.black.withAlpha(25),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(12),
                      child: TabBar(
                        controller: _tab2Controller,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          insets:
                              const EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 0.0),
                        ),
                        tabs: [
                          _buildTabItem('Cliente', activeTab2Index, 0),
                          _buildTabItem('Motorista', activeTab2Index, 1),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          CreateAccountForm(activeTabIndex: activeTab2Index),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              // const SizedBox(height: 24),
              // AppButton(
              //   label: "Conectar com Facebook",
              //   backgroundColor: HexColor('#2672CB'),
              //   onClick: () {},
              // ),
              const SizedBox(height: 24),
              Text.rich(
                TextSpan(
                  text: 'Ao clicar em criar conta, você concorda com nossos ',
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Termos e condições',
                      style: TextStyle(fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          launchUrl(Uri.parse('https://www.google.com'));
                        },
                    ),
                    TextSpan(text: '.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _buildTabItem(String text, int currentTab, int tab) {
  return Tab(
    child: Text(
      text,
      style: TextStyle(
        color: currentTab == tab ? Colors.black : Colors.grey.shade400,
        fontWeight: FontWeight.w500,
        fontSize: 22,
        letterSpacing: 2,
      ),
    ),
  );
}
