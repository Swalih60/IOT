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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
        elevation: 2,
      ),
      body: context.watch<CartProvider>().item_name.isEmpty
          ? const Center(child: Text("Empty Cart"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: context.watch<CartProvider>().item_name.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Image.network(
                          context.watch<CartProvider>().item_img[index],
                          height: 40,
                          width: 40,
                        ),
                        title: Text(
                            context.watch<CartProvider>().item_name[index]),
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
                        builder: (context) => QrScreen(),
                      ));
                    },
                    child: const Text('Buy Now'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full width
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
