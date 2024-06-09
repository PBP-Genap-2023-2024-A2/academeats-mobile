import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth/auth.dart';
import '../order/screens/order_screen_for_pembeli.dart'; // Ensure this import is correct
import '../utils/fetch.dart';
import 'package:academeats_mobile/models/keranjang.dart';

class KeranjangScreen extends StatefulWidget {
  KeranjangScreen({super.key});

  @override
  _KeranjangScreenState createState() => _KeranjangScreenState();
}

class _KeranjangScreenState extends State<KeranjangScreen> {
  late Future<Map<String, dynamic>> _keranjangData;
  List<int> selectedItems = [];
  ValueNotifier<double> totalHargaNotifier = ValueNotifier<double>(0.0);

  @override
  void initState() {
    super.initState();
    AuthProvider auth = context.read<AuthProvider>();
    String username = auth.user!.username;
    _fetchKeranjangData(username);
  }

  void _fetchKeranjangData(String username) {
    setState(() {
      _keranjangData = fetchData('keranjang/api/v1/get-keranjang-item/$username/');
    });
  }

  void _updateTotalHarga() {
    double total = 0.0;
    _keranjangData.then((response) {
      response['data'].forEach((item) {
        final keranjangItem = KeranjangItem.fromJson(item);
        if (selectedItems.contains(keranjangItem.id)) {
          total += keranjangItem.makanan.harga * keranjangItem.jumlah;
        }
      });
      totalHargaNotifier.value = total;
    });
  }

  Future<void> _checkoutItems(BuildContext context, String username) async {
    final double totalHarga = totalHargaNotifier.value;
    final body = {
      'obj': selectedItems,
      'total_harga': totalHarga,
    };
    print('body: $body');

    try {
      final response = await fetchData(
        'keranjang/api/v1/flutter-checkout-cart/$username/',
        method: RequestMethod.post,
        body: body,
      );

      print('response: $response');

      if (response['message'] == 'Checkout successful') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderScreenForPembeli(),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Failed to checkout')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to checkout: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();
    String username = auth.user!.username;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keranjang'),
      ),
      body: FutureBuilder(
        future: _keranjangData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snapshot.data!['data'].length,
              itemBuilder: (context, index) {
                final keranjangItem = KeranjangItem.fromJson(snapshot.data!['data'][index]);
                return KeranjangCard(
                  keranjangItem: keranjangItem,
                  isSelected: selectedItems.contains(keranjangItem.id),
                  onItemChanged: () => _fetchKeranjangData(username),
                  onItemSelected: (bool isSelected) {
                    setState(() {
                      if (isSelected) {
                        selectedItems.add(keranjangItem.id);
                      } else {
                        selectedItems.remove(keranjangItem.id);
                      }
                      _updateTotalHarga();
                    });
                  },
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<double>(
              valueListenable: totalHargaNotifier,
              builder: (context, value, child) {
                return Text(
                  'Total Harga: Rp${value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              },
            ),
            ElevatedButton(
              onPressed: selectedItems.isEmpty
                  ? null
                  : () {
                _checkoutItems(context, username);
              },
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}

class KeranjangCard extends StatefulWidget {
  final KeranjangItem keranjangItem;
  final bool isSelected;
  final VoidCallback onItemChanged;
  final ValueChanged<bool> onItemSelected;

  KeranjangCard({
    required this.keranjangItem,
    required this.isSelected,
    required this.onItemChanged,
    required this.onItemSelected,
  });

  @override
  _KeranjangCardState createState() => _KeranjangCardState();
}

class _KeranjangCardState extends State<KeranjangCard> {
  late KeranjangItem keranjangItem;
  late bool isSelected;

  @override
  void initState() {
    super.initState();
    keranjangItem = widget.keranjangItem;
    isSelected = widget.isSelected;
  }

  Future<void> _updateQuantity(BuildContext context, int newQuantity) async {
    final int keranjangId = keranjangItem.id;

    try {
      final response = await fetchData(
        'keranjang/cek-stok/$keranjangId',
      );

      if (response['message'] == 'success') {
        int stock = response['stok'];
        if (newQuantity > stock && context.mounted) {
          _showMessage(context, 'Quantity exceeds stock available');
          return;
        }

        final updateResponse = await fetchData(
          'keranjang/api/v1/flutter-update-jumlah/$keranjangId/',
          method: RequestMethod.post,
          body: {'jumlah': newQuantity},
        );

        if (updateResponse['status'] == 'success') {
          setState(() {
            keranjangItem.jumlah = newQuantity;
          });
          widget.onItemChanged();
        } else if (context.mounted) {
          _showMessage(context, updateResponse['message'] ?? 'Failed to update quantity');
        }
      } else if (context.mounted) {
        _showMessage(context, response['message'] ?? 'Failed to fetch item data');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Failed to update quantity: $e');
      }
    }
  }

  Future<void> _deleteItem(BuildContext context) async {
    try {
      final response = await fetchData(
        'keranjang/api/v1/flutter-delete-item/${keranjangItem.id}/',
        method: RequestMethod.post,
      );

      if (response['message'] == 'success') {
        widget.onItemChanged();
      } else if (context.mounted) {
        _showMessage(context, response['message'] ?? 'Failed to delete item');
      }
    } catch (e) {
      if (context.mounted) {
        _showMessage(context, 'Failed to delete item: $e');
      }
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
            Row(
              children: [
                Checkbox(
                  value: isSelected,
                  onChanged: (bool? value) {
                    setState(() {
                      isSelected = value ?? false;
                    });
                    widget.onItemSelected(isSelected);
                  },
                ),
                Expanded(
                  child: Text(
                    keranjangItem.makanan.nama,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Jumlah: ${keranjangItem.jumlah}',
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        if (keranjangItem.jumlah > 1) {
                          _updateQuantity(context, keranjangItem.jumlah - 1);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _updateQuantity(context, keranjangItem.jumlah + 1);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteItem(context),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

