import 'package:sjmototaxi_app/widget/common/history_card.dart';
import 'package:sjmototaxi_app/widget/layout/SimpleAppBar.dart';
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          appBar: const SimpleAppBar(
            title: 'Histórico',
            isDark: false,
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 64,
                decoration:
                    BoxDecoration(color: Theme.of(context).primaryColor),
              ),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: const Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        top: -48,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            HistoryCard(),
                            SizedBox(height: 12),
                            HistoryCard(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
