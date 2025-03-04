import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class QrScreen extends StatefulWidget {
  const QrScreen({
    super.key,
    required this.items,
  });

  final List items;

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen> {
  late String qrData;
  late Timer _timer;
  int _start = 43200;
  bool _isExpired = false;
  late String transactionCode;
  final SupabaseClient supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _generateTransactionCode();
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

      // Check if code exists in database
      final result = await supabase
          .from('transactions')
          .select()
          .eq('transaction_code', code)
          .single();
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    // Mark as expired if not used
    if (!_isExpired) {
      supabase.from('transactions').update({'status': 'EXPIRED'}).eq(
          'transaction_code', transactionCode);
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isExpired = true;
        });
        _timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  String _generateQrData(List items) {
    // Add transaction code at the beginning
    String data = '$transactionCode|';

    List<String> itemDetails = items.map((item) {
      String name = item['name'] ?? 'Unknown';
      int quantity = item['quantity'] ?? 0;
      return '$name $quantity';
    }).toList();

    return data + itemDetails.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                QrImageView(
                  data: qrData,
                  size: 300,
                ),
                if (_isExpired)
                  const Icon(
                    Icons.cancel,
                    color: Colors.red,
                    size: 300,
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              _isExpired
                  ? "QR Code Expired"
                  : "Time Remaining: ${(_start / 3600).floor()}h ${((_start % 3600) / 60).floor()}m",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isExpired ? Colors.red : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
