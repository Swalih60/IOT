import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:iot/providers/cart_provider.dart';
import 'package:iot/screens/store_screen.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({
    super.key,
    required this.items,
    required this.amount,
  });

  final List items;
  final double amount;

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  late String qrData = " ";
  late String transactionCode;
  final bool _isExpired = false;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _generateTransactionCode();
    // Clear the cart after successful payment
    context.read<CartProvider>().clearCart();
  }

  Future<void> _generateTransactionCode() async {
    // Generate a random 12-character alphanumeric code
    String code;
    bool isUnique = false;

    while (!isUnique) {
      code = '';
      const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
      final random = Random();

      for (var i = 0; i < 12; i++) {
        code += chars[random.nextInt(chars.length)];
      }

      try {
        // Check if code exists in database
        await supabase
            .from('transactions')
            .select()
            .eq('transaction_code', code)
            .single();
      } catch (e) {
        // If no record found (throws error), the code is unique
        isUnique = true;
        transactionCode = code;
        qrData = _generateQrData(widget.items);
        setState(() {}); // Update the UI with the new QR code

        // Insert transaction record into the database
        await supabase.from('transactions').insert({
          'uid': Supabase.instance.client.auth.currentUser?.id,
          'created_at': DateTime.now().toIso8601String(),
          'transaction_code': transactionCode,
          'status': 'NOT_USED',
          'items': widget.items.map((item) => item['name']).toList(),
        });
        break;
      }
    }
  }

  @override
  void dispose() {
    // Mark as expired if not used
    if (!_isExpired) {
      supabase.from('transactions').update({'status': 'EXPIRED'}).eq(
          'transaction_code', transactionCode);
    }
    super.dispose();
  }

  String _generateQrData(List items) {
    // Add transaction code at the beginning
    String data = '$transactionCode|';

    List<String> itemDetails = items.map((item) {
      String position = item['pos'] ?? 'Unknown';
      int quantity = item['quantity'] ?? 0;
      return '$position $quantity';
    }).toList();

    return data + itemDetails.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Custom Back Button
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 36),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const StoreScreen(),
                )); // Navigate to store screen
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // QR Code
                  QrImageView(
                    backgroundColor: Colors.white,
                    data: qrData,
                    version: QrVersions.auto,
                    size: 300.0,
                  ),
                  const SizedBox(height: 20),

                  // Transaction Code
                  // Text(
                  //   'Transaction Code: $transactionCode',
                  //   style:
                  //       const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  // ),
                  const SizedBox(height: 20),

                  // Items List
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Order Details:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...widget.items.map((item) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${item['name']}'),
                                  Text('x${item['quantity']}'),
                                ],
                              ),
                            )),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '₹${widget.amount.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
