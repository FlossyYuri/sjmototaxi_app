import 'package:agotaxi/widget/forms/login_form.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginTab extends StatelessWidget {
  const LoginTab({
    super.key,
    required TabController tabController,
    required this.activeTabIndex,
  }) : _tabController = tabController;

  final TabController _tabController;
  final int activeTabIndex;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
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
                        controller: _tabController,
                        indicatorColor: Colors.black,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 4.0,
                          ),
                          borderRadius: BorderRadius.circular(4),
                          insets:
                              const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                        ),
                        tabs: [
                          _buildTabItem('Entrar', activeTabIndex, 0),
                          _buildTabItem('Criar conta', activeTabIndex, 1),
                        ],
                      ),
                    ),
                    Divider(color: Colors.grey.shade300),
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Column(
                        children: [
                          LoginForm(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
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
                    const TextSpan(text: '.'),
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
