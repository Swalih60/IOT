import 'package:flutter/material.dart';
import 'package:iot/screens/qrcode_screen.dart';
import 'package:iot/services/database_service.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorpayPaymentScreen extends StatefulWidget {
  final double amount;
  final List items;

  const RazorpayPaymentScreen({
    super.key,
    required this.amount,
    required this.items,
  });

  @override
  _RazorpayPaymentScreenState createState() => _RazorpayPaymentScreenState();
}

class _RazorpayPaymentScreenState extends State<RazorpayPaymentScreen> {
  late Razorpay _razorpay;
  bool _isProcessing = false;

  SupaBase db = SupaBase();
  @override
  void initState() {
    super.initState();
    _initializeRazorpay();
  }

  void _initializeRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    _showSnackBar("Payment Successful: ${response.paymentId}");
    for (var item in widget.items) {
      await db.decrementQuant(
        name: item["name"] ?? "item_name",
        decrementValue: int.tryParse(item["quantity"].toString()) ?? 0,
      );
    }
    _navigateToQrScreen();
  }

  Future<void> _handlePaymentError(PaymentFailureResponse response) async {
    _showSnackBar("Payment Failed: ${response.message ?? 'Error occurred'}");
    setState(() {
      _isProcessing = false;
    });
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar("External Wallet Selected: ${response.walletName}");
    setState(() {
      _isProcessing = false;
    });
  }

  void _openRazorpayCheckout() {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
    });

    // Create description from items list
    String description = widget.items
        .map((item) => '${item['name']} x${item['quantity']}')
        .join(', ');
    description += '\nTotal Amount: ₹${widget.amount.toStringAsFixed(2)}';

    // Amount should be in paise (multiply by 100)
    int amountInPaise = (widget.amount * 100).toInt();

    var options = {
      'key': 'rzp_test_Fg3mWibuyZLlns', // Replace with your actual key
      'amount': amountInPaise,
      'name': 'I-VEND', // Replace with your store name
      'description': description,
      'prefill': {
        'contact': '', // Optional: Prefill customer phone
        'email': '', // Optional: Prefill customer email
      },
      'external': {
        'wallets': ['paytm'] // Optional: Specify external wallets
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      _showSnackBar("Error: ${e.toString()}");
      setState(() {
        _isProcessing = false;
      });
    }
  }

  void _navigateToQrScreen() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QrScreen(
          items: widget.items,
          amount: widget.amount,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _razorpay.clear(); // Clear all event listeners
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Amount: ₹${widget.amount.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 40),
              if (_isProcessing)
                const CircularProgressIndicator()
              else
                ElevatedButton(
                  onPressed: _openRazorpayCheckout,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Pay Now',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
