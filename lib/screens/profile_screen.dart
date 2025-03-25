import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Custom App Bar with Profile Info
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                user?.userMetadata?['username'] ?? "No Name",
                style: const TextStyle(color: Colors.white),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 50, color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "CSE • S8",
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Purchase History Header
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(Icons.history, size: 28),
                  SizedBox(width: 8),
                  Text(
                    "Purchase History",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Purchase History List
          SliverFillRemaining(
            child: FutureBuilder(
              future: Supabase.instance.client
                  .from('transactions')
                  .select()
                  .eq('uid', user?.id ?? '')
                  .order('created_at', ascending: false),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data.isEmpty) {
                  return const Center(child: Text('No transactions found.'));
                }

                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data[index];
                    return ListTile(
                      title: Text('Date: ${transaction['created_at']}'),
                      subtitle: Text('Status: ${transaction['status']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PurchaseDetailScreen(
                              purchaseId: transaction['transaction_code'],
                              items: transaction['items'],
                              status: transaction['status'],
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// New screen for purchase details

class PurchaseDetailScreen extends StatelessWidget {
  final String purchaseId;
  final List items;
  final String status;

  const PurchaseDetailScreen({
    super.key,
    required this.purchaseId,
    required this.items,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Purchase Details'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // QR Code Display
          Container(
            padding: const EdgeInsets.all(16),
            child: Image.network(
              'https://api.qrserver.com/v1/create-qr-code/?data=$purchaseId',
              height: 400,
              width: 400,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.qr_code, size: 200),
            ),
          ),
          // Status Display
          Text(status == 'EXPIRED'
              ? 'This QR code has expired'
              : 'This QR code is valid'),

          const SizedBox(
            height: 10,
          ),

          const Text(
            "ITEMS",
            style: TextStyle(fontSize: 26),
          ),
          // Product List
          Expanded(
            child: ListView.builder(
              itemCount: items.length ?? 0,
              itemBuilder: (context, index) {
                // final item = items[index];
                return ListTile(
                  title: Text(items[index] ?? 'Unknown Product'),
                  // subtitle: Text('Quantity: ${item['quantity']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
