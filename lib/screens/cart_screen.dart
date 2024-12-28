import 'package:flutter/material.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/screens/qrcode_screen.dart';
import 'package:iot/services/database_service.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  SupaBase db = SupaBase();
  List<Map<String, dynamic>> items = [];

  Future<void> _processOrder() async {
    try {
      // Process each item sequentially
      for (var item in items) {
        await db.decrementQuant(
          name: item["name"] ?? "item_name",
          decrementValue: int.tryParse(item["quantity"].toString()) ?? 0,
        );
      }

      if (mounted) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => QrScreen(items: items),
        ));
      }
    } catch (e) {
      print('Error processing order: $e');
    }
  }

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
                      final cartItem =
                          context.watch<CartProvider>().items[index];
                      // Update items list for each rebuild
                      items = context
                          .watch<CartProvider>()
                          .items
                          .map((item) => {
                                'name': item["item_name"],
                                'quantity': item["item_quant"],
                              })
                          .toList();

                      return ListTile(
                        leading: Image.network(
                          cartItem["item_img"],
                          height: 40,
                          width: 40,
                        ),
                        title: Text(cartItem["item_name"]),
                        subtitle: Text(cartItem["item_quant"].toString()),
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Confirm Order"),
                            actions: [
                              IconButton(
                                onPressed: () => Navigator.of(context).pop(),
                                icon: const Icon(Icons.cancel),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  _processOrder();
                                },
                                icon: const Icon(Icons.check),
                              ),
                            ],
                          );
                        },
                      );
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
