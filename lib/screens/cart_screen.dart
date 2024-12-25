import 'package:flutter/material.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/screens/qrcode_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> items = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        elevation: 2,
      ),
      body: context.watch<CartProvider>().items.isEmpty
          ? const Center(child: Text("Empty Cart"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: context.watch<CartProvider>().items.length,
                    itemBuilder: (context, index) {
                      items.add({
                        'name':
                            Provider.of<CartProvider>(context, listen: false)
                                .items[index]["item_name"],
                        'quantity':
                            Provider.of<CartProvider>(context, listen: false)
                                .items[index]["item_quant"],
                      });
                      return ListTile(
                        leading: Image.network(
                          context.watch<CartProvider>().items[index]
                              ["item_img"],
                          height: 40,
                          width: 40,
                        ),
                        title: Text(context.watch<CartProvider>().items[index]
                            ["item_name"]),
                        subtitle: Text(context
                            .watch<CartProvider>()
                            .items[index]["item_quant"]
                            .toString()),
                        trailing: IconButton(
                          onPressed: () {
                            context
                                .read<CartProvider>()
                                .removeItem(index: index);
                            setState(() {});
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QrScreen(
                          items: items,
                        ),
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Buy Now'),
                  ),
                ),
              ],
            ),
    );
  }
}
