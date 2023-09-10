import 'package:agotaxi/screens/Client/checkout/delivery_screen.dart';
import 'package:agotaxi/widget/vendor/CatalogueItem.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final items = List<String>.generate(20, (i) => 'Item ${i + 1}');
  int varQuant = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HexColor("#F5F5F8"),
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: HexColor("#F5F5F8"),
        elevation: 0.0,
        bottomOpacity: 0.0,
        title: const Text(
          "Carrinho",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
        toolbarHeight: 90,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const Text(
              'Deslize o item para apagar',
              style: TextStyle(
                fontSize: 12,
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 6,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(item),
                        onDismissed: (direction) {
                          setState(() {
                            items.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$item removido')));
                        },
                        background: Container(
                          color: HexColor("#F5F5F8"),
                          padding: const EdgeInsets.all(20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        child: const CatalogueItem(),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text("Subtotal"), Text("580,00 MT")],
            ),
            const SizedBox(
              height: 12,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Taxa de Entrega",
                  style: TextStyle(color: Colors.deepOrange),
                ),
                Text(
                  "100,00 MT",
                  style: TextStyle(color: Colors.deepOrange),
                ),
              ],
            ),
            const Divider(),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "680,00 MT",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                )
              ],
            ),
            const Divider(),
            const SizedBox(
              height: 16,
            ),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DeliveryScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Theme.of(context).primaryColor,
                      ),
                      child: const Text(
                        "Completar encomenda",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
          ],
        ),
      ),
    );
  }
}
