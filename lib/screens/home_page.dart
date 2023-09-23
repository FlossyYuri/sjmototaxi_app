import 'package:agotaxi/screens/Common/chat_screen.dart';
import 'package:agotaxi/screens/Common/history_screen.dart';
import 'package:agotaxi/screens/Common/wallet_screen.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },
                child: Text('History')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatScreen(),
                    ),
                  );
                },
                child: Text('Mensagem')),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const WalletScreen(),
                  ),
                );
              },
              child: Text('Carteira'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              child: Text('Cart'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/delivery');
              },
              child: Text('Entrega'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/rate');
              },
              child: Text('Avaliar'),
            ),
            Divider(),
            ElevatedButton(onPressed: () {}, child: Text('Splash 1')),
            ElevatedButton(onPressed: () {}, child: Text('Oboarding')),
            ElevatedButton(onPressed: () {}, child: Text('Sign Up')),
            ElevatedButton(onPressed: () {}, child: Text('Sign In')),
            ElevatedButton(
                onPressed: () {}, child: Text('Setup GPS locations')),
          ],
        ),
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, int carouselIndex) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text('Carousel $carouselIndex'),
        SizedBox(
          // you may want to use an aspect ratio here for tablet support
          height: 200.0,
          child: PageView.builder(
            // store this controller in a State to save the carousel scroll position
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (BuildContext context, int itemIndex) {
              return _buildCarouselItem(context, carouselIndex, itemIndex);
            },
          ),
        )
      ],
    );
  }

  Widget _buildCarouselItem(
      BuildContext context, int carouselIndex, int itemIndex) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(4.0)),
        ),
      ),
    );
  }
}
