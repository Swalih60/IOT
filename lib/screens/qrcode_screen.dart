import 'dart:async';

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
  int _start = 60;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    qrData = _generateQrData(widget.items);
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
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
    List<String> itemDetails = items.map((item) {
      String name = item['name'] ?? 'Unknown';
      int quantity = item['quantity'] ?? 0;
      return '$name $quantity';
    }).toList();
    return itemDetails.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Single QR Code Generator"),
      ),
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
              _isExpired ? "QR Code Expired" : "Time Remaining: $_start s",
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
