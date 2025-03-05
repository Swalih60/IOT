import 'package:flutter/material.dart';
import 'package:iot/auth/login_screen.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/providers/store_provider.dart';
import 'package:iot/providers/value_provider.dart';
import 'package:iot/screens/cart_screen.dart';
import 'package:iot/services/database_service.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  SupaBase db = SupaBase();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  bool check(String name) {
    final it = context.watch<CartProvider>().items;
    return !it.any((i) => i["item_name"] == name);
  }

  Future<void> _loadItems() async {
    try {
      context.read<StoreProvider>().clearItems();

      for (int i = 1; i <= 6; i++) {
        final item = await db.readItem(id: i);
        if (item != null) {
          // ignore: use_build_context_synchronously
          context.read<StoreProvider>().addItems(item: item);
        }
      }
      // ignore: use_build_context_synchronously
      context.read<StoreProvider>().setLoading();
    } catch (e) {
      print("Error loading items: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("I-VEND"),
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
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CartScreen()));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              child: const Icon(
                Icons.logout,
                size: 30,
              ),
              onTap: () async {
                await Supabase.instance.client.auth.signOut().then((value) =>
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const GlassLoginScreen(),
                    )));
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadItems,
        child: context.watch<StoreProvider>().loading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: 6,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 20,
                    mainAxisExtent: 300),
                itemBuilder: (context, index) {
                  final item = context.watch<StoreProvider>().items[index];
                  final String name = item["item"] ?? "unknown";
                  final int quant = item["quantity"] ?? 0;
                  final String pic = item["pic"] ?? "unknown";
                  final int price = item["price"] ?? 0;
                  bool vis = quant > 0;

                  // Generate position dynamically (A1, A2, B1, B2, C1, C2, ...)
                  int row = index ~/ 2; // Determine row (0, 1, 2,...)
                  int col = index % 2; // Determine column (0 or 1)
                  String rowLetter =
                      String.fromCharCode(65 + row); // Convert to A, B, C...
                  String position =
                      "$rowLetter${col + 1}"; // Combine row and column

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
                            ),
                          ),
                          Text(name),
                          Text("Quantity : $quant"),
                          Text("Price : $price"),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                              onPressed: check(item["item"])
                                  ? () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                            title: const Text("Confirm"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.remove),
                                                      onPressed: context
                                                                  .watch<
                                                                      ValueProvider>()
                                                                  .value ==
                                                              0
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                      ValueProvider>()
                                                                  .decrement();
                                                            },
                                                    ),
                                                    Text(
                                                      '${context.watch<ValueProvider>().value}',
                                                      style: const TextStyle(
                                                          fontSize: 24),
                                                    ),
                                                    IconButton(
                                                      icon:
                                                          const Icon(Icons.add),
                                                      onPressed: context
                                                                  .watch<
                                                                      ValueProvider>()
                                                                  .value ==
                                                              quant
                                                          ? null
                                                          : () {
                                                              context
                                                                  .read<
                                                                      ValueProvider>()
                                                                  .increment();
                                                            },
                                                    ),
                                                  ],
                                                ),
                                                const Text(
                                                  "Are you sure you want to add this item to cart?",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ],
                                            ),
                                            actions: [
                                              IconButton(
                                                  onPressed: () {
                                                    final value = Provider.of<
                                                            ValueProvider>(
                                                        context,
                                                        listen: false);
                                                    context
                                                        .read<CartProvider>()
                                                        .addItem(
                                                            item: name,
                                                            img: pic,
                                                            quant: value.value,
                                                            price: price,
                                                            pos: position);
                                                    context
                                                        .read<ValueProvider>()
                                                        .reset();
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.check)),
                                              const SizedBox(
                                                width: 20,
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  icon:
                                                      const Icon(Icons.close)),
                                            ]),
                                      );
                                    }
                                  : null,
                              child: const Icon(Icons.shopping_cart)),
                          const SizedBox(
                            height: 50,
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
