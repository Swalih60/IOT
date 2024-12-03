import 'package:flutter/material.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/screens/cart_screen.dart';
import 'package:iot/services/database_service.dart';
import 'package:provider/provider.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  SupaBase db = SupaBase();
  final List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    loadItems();
  }

  Future<void> loadItems() async {
    for (int i = 1; i <= 6; i++) {
      final itemData = await db.readItem(id: i);
      if (itemData != null) {
        setState(() {
          items.add(itemData);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SHOP"),
        centerTitle: true,
        elevation: 20,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(
                Icons.shopping_cart,
                size: 30,
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const CartScreen()),
                );
              },
            ),
          ),
        ],
      ),
      body: items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                mainAxisExtent: 260,
              ),
              itemBuilder: (context, index) {
                final item = items[index];
                final String name = item["name"] ?? "unknown";
                final int quant = item["quantity"] ?? 0;
                final String pic = item["pic"] ?? "unknown";
                final int price = item["price"] ?? 0;
                bool vis = quant > 0;

                return Offstage(
                  offstage: !vis,
                  child: Card(
                    elevation: 20,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Image.network(
                            pic,
                            width: 100,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) =>
                                const Text("Image not available"),
                          ),
                        ),
                        Text(name),
                        Text("Quantity : $quant"),
                        Text("Price : $price"),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                  "Are you sure you want to add this item to cart?",
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read<CartProvider>()
                                          .addItem(item: name, img: pic);
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.check),
                                  ),
                                  const SizedBox(width: 20),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: const Icon(Icons.shopping_cart),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
