import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth/auth.dart';
import '../order/screens/order_screen_for_pembeli.dart'; // Ensure this import is correct
import '../utils/fetch.dart';
import 'package:academeats_mobile/models/keranjang.dart';

class KeranjangScreen extends StatelessWidget {
  KeranjangScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();
    String username = auth.user!.username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: FutureBuilder(
        future: fetchData('keranjang/api/v1/get-keranjang-item/$username'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshot.data!['data'].length,
              itemBuilder: (context, index) {
                final keranjangItem = KeranjangItem.fromJson(snapshot.data!['data'][index]);
                return KeranjangCard(keranjangItem: keranjangItem, onItemChanged: () => (context as Element).markNeedsBuild());
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _checkoutItems(context, username); // Checkout button calls the API and navigates
        },
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }

  Future<void> _checkoutItems(BuildContext context, String username) async {
    try {
      final response = await fetchData(
        'keranjang/api/v1/checkout-items/$username',
        method: RequestMethod.post,
      );

      if (response['status'] == 'success') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreenForPembeli(),
          ),
        );
      } else {
        // Handle the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to checkout')),
        );
      }
    } catch (e) {
      // Handle network errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to checkout: $e')),
      );
    }
  }
}

class KeranjangCard extends StatelessWidget {
  final KeranjangItem keranjangItem;
  final VoidCallback onItemChanged;

  KeranjangCard({required this.keranjangItem, required this.onItemChanged});

  Future<void> _updateQuantity(int newQuantity) async {
    try {
      final response = await fetchData(
        'keranjang/api/v1/get-item-quantity-and-stock/${keranjangItem.makanan.id}',
      );

      if (response['status'] == 'success') {
        int stock = response['data']['stock'];

        if (newQuantity > stock) {
          // Show an error message if the quantity exceeds stock
          _showMessage(context, 'Quantity exceeds stock available');
          return;
        }

        // Update the quantity
        final updateResponse = await fetchData(
          'keranjang/api/v1/update-quantity/${keranjangItem.id}',
          method: RequestMethod.post,
          body: {'quantity': newQuantity},
        );

        if (updateResponse['status'] == 'success') {
          onItemChanged();
        } else {
          _showMessage(context, updateResponse['message'] ?? 'Failed to update quantity');
        }
      } else {
        _showMessage(context, response['message'] ?? 'Failed to fetch item data');
      }
    } catch (e) {
      _showMessage(context, 'Failed to update quantity: $e');
    }
  }

  Future<void> _deleteItem() async {
    try {
      final response = await fetchData(
        'keranjang/api/v1/delete-item/${keranjangItem.id}',
        method: RequestMethod.post,
      );

      if (response['status'] == 'success') {
        onItemChanged();
      } else {
        _showMessage(context, response['message'] ?? 'Failed to delete item');
      }
    } catch (e) {
      _showMessage(context, 'Failed to delete item: $e');
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              keranjangItem.makanan.nama,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Jumlah: ${keranjangItem.jumlah}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (keranjangItem.jumlah > 1) {
                      _updateQuantity(keranjangItem.jumlah - 1);
                    }
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    _updateQuantity(keranjangItem.jumlah + 1);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: _deleteItem,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
