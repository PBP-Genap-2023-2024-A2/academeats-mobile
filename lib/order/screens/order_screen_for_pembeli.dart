import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../auth/auth.dart';
import '../../keranjang/keranjang_screen.dart';
import '../../models/order_group.dart';
import '../../models/order.dart';
import '../../review/create_review.dart';

class OrderScreenForPembeli extends StatefulWidget {
  OrderScreenForPembeli({super.key});

  @override
  _OrderScreenForPembeliState createState() => _OrderScreenForPembeliState();
}

class _OrderScreenForPembeliState extends State<OrderScreenForPembeli> {
  late Future<Map<String, dynamic>> _orderData;

  @override
  void initState() {
    AuthProvider auth = Provider.of<AuthProvider>(context, listen: false);
    String username = auth.user?.username ?? "";
    super.initState();
    _fetchOrderData(username);
  }

  void _fetchOrderData(String username) {
    setState(() {
      _orderData = fetchData('order/api/v1/flutter_get_og_by_user/$username/');
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();
    String username = auth.user?.username ?? "";
    return Scaffold(
      appBar: AppBar(
          title: const Text('Order'),
          actions: [
      IconButton(
      icon: const Icon(Icons.shopping_cart),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => KeranjangScreen(),
          ),
        );
      },
    ),
    ]
    ),
      body: FutureBuilder(
        future: _orderData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<OrderGroup> orderGroups = (snapshot.data!['data'] as List)
                .map((data) => OrderGroup.fromJson(data))
                .toList();

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orderGroups.length,
              itemBuilder: (context, index) {
                final orderGroup = orderGroups[index];

                return OrderGroupCard(
                  orderGroup: orderGroup,
                  onOrderCanceled: () => _fetchOrderData(username), // Pass the function as a callback
                );
              },
            );
          }
        },
      ),
    );
  }
}

class OrderGroupCard extends StatelessWidget {
  final OrderGroup orderGroup;
  final VoidCallback onOrderCanceled;

  OrderGroupCard({
    required this.orderGroup,
    required this.onOrderCanceled,
  });

  @override
  Widget build(BuildContext context) {
    List<Order> orders = orderGroup.orders;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Order ID: ${orderGroup.id}'),
                  Text('Total: Rp${orderGroup.totalHarga}'),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _buildOrderCard(order, context);
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(color: Colors.brown),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Status Pesanan:'),
                      Text(orderGroup.status),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: (orderGroup.status == 'DIBATALKAN' || orderGroup.status == 'SELESAI')
                        ? null
                        : () async {
                      await cancelOrder(orderGroup);
                      onOrderCanceled(); // Trigger the callback to refresh the UI
                    },
                    child: const Text('Batalkan Pesanan'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderCard(Order order, BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text(order.nama),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Jumlah: ${order.quantity}'),
              ],
            ),
            if (order.status == 'SELESAI')
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReviewFormPage(makanans: order.makanan),
                      ),
                    );
                  },
                  child: const Text('Review'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> cancelOrder(OrderGroup og) async {
    final int ogId = og.id;
    try {
      final response = await fetchData(
        'order/edit_status_batal/$ogId',
        method: RequestMethod.post,
        body: {
          'og_id': og.id,
        },
      );

      if (response['status'] == 'success') {
        await _returnStock(og);
        for (Order order in og.orders) {
          // Fetch the makanan stock update API
          order.status = "DIBATALKAN";
        }
      } else {
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> _returnStock(OrderGroup orderGroup) async {
    try {
      final response = await fetchData(
        'order/return_stok/${orderGroup.id}',
        method: RequestMethod.post,
      );

      if (response['status'] != 'success') {
        final errorMessage = response['message'] ?? 'Failed to return stock';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to return stock: $e');
    }
  }
}
