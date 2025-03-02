import 'package:flutter/material.dart';
import 'package:iot/screens/qrcode_screen.dart';
import 'package:upi_india/upi_india.dart';

class UPIPaymentScreen extends StatefulWidget {
  final double amount;
  final List items;

  const UPIPaymentScreen({
    super.key,
    required this.amount,
    required this.items,
  });

  @override
  _UPIPaymentScreenState createState() => _UPIPaymentScreenState();
}

class _UPIPaymentScreenState extends State<UPIPaymentScreen> {
  Future<UpiResponse>? _transaction;
  final UpiIndia _upiIndia = UpiIndia(); // Make final
  List<UpiApp>? apps;
  bool _isProcessing = false; // Add loading state

  @override
  void initState() {
    super.initState();
    _loadUpiApps();
  }

  Future<void> _loadUpiApps() async {
    try {
      if (!mounted) return; // Check if widget is mounted
      final loadedApps =
          await _upiIndia.getAllUpiApps(mandatoryTransactionId: false);
      if (!mounted) return;

      setState(() {
        apps = loadedApps;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        apps = [];
      });
      _showSnackBar("Failed to load UPI apps: ${e.toString()}");
    }
  }

  // Helper method for showing snackbars
  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<UpiResponse> initiateTransaction(UpiApp app) async {
    if (widget.amount <= 0) {
      throw Exception("Please enter a valid amount");
    }

    final String transactionRef = 'TXN${DateTime.now().millisecondsSinceEpoch}';

    try {
      return await _upiIndia.startTransaction(
        app: app,
        receiverUpiId:
            "mohammedsalih050@oksbi", // Consider making this configurable
        receiverName: 'Mohammad Salih V S',
        transactionRefId: transactionRef,
        transactionNote: 'Payment for items',
        amount: widget.amount,
      );
    } catch (e) {
      // For testing add razorpay after testing
      _navigateToQrScreen();
      throw Exception("Failed to initiate transaction: ${e.toString()}");
    }
  }

  Widget displayUpiApps() {
    if (apps == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (apps!.isEmpty) {
      return const Center(
        child: Text(
          "No UPI apps found to handle payment.",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 16.0,
      runSpacing: 16.0,
      children: apps!.map<Widget>((UpiApp app) {
        return GestureDetector(
          onTap: _isProcessing ? null : () => _handleAppSelection(app),
          child: Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.memory(
                  app.icon,
                  height: 60,
                  width: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  app.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _handleAppSelection(UpiApp app) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _transaction = initiateTransaction(app);
    });

    try {
      final response = await _transaction;
      if (mounted) {
        _checkTxnStatus(response!);
      }
    } catch (e) {
      if (mounted) {
        _showSnackBar(e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  String _upiErrorHandler(error) {
    switch (error) {
      case UpiIndiaAppNotInstalledException:
        return 'Requested app not installed on device';
      case UpiIndiaUserCancelledException:
        return 'You cancelled the transaction';
      case UpiIndiaNullResponseException:
        return 'Requested app didn\'t return any response';
      case UpiIndiaInvalidParametersException:
        return 'Requested app cannot handle the transaction';
      default:
        return 'An Unknown error has occurred: ${error.toString()}';
    }
  }

  void _checkTxnStatus(UpiResponse upiResponse) {
    final String status = upiResponse.status ?? 'N/A';

    switch (status) {
      case UpiPaymentStatus.SUCCESS:
        _showSnackBar('Transaction Successful');
        _navigateToQrScreen();
        break;
      case UpiPaymentStatus.SUBMITTED:
        _showSnackBar('Transaction Submitted');
        break;
      case UpiPaymentStatus.FAILURE:
        _showSnackBar('Transaction Failed');
        break;
      default:
        _showSnackBar('Transaction Status: $status');
    }
  }

  void _navigateToQrScreen() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => QrScreen(items: widget.items),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UPI Payment'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Amount: ₹${widget.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select a payment app:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: displayUpiApps(),
          ),
          if (_isProcessing)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Processing Transaction...'),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
