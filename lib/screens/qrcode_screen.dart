import 'package:flutter/material.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: QrImageView(
          data: context.watch<CartProvider>().items[0]["item_name"],
          size: 300,
        ),
      ),
    );
  }
}
