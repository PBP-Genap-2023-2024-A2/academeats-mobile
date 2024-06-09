import 'package:flutter/material.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import '../../keranjang/keranjang_screen.dart';
import '../../models/order.dart';

class OrderScreenForPenjual extends StatelessWidget {
  final int tokoId;

  OrderScreenForPenjual(this.tokoId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Order')
      ),
      body: FutureBuilder(
        future: fetchData('order/api/v1/$tokoId/orders'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshot.data!['data'].length,
              itemBuilder: (context, index) {
                final order = Order.fromJson(snapshot.data!['data'][index]);
                return OrderCard(order: order);
              },
            );
          }
        },
      ),
    );
  }
}

class OrderCard extends StatefulWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

  @override
  _OrderCardState createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  late Order order;

  @override
  void initState() {
    super.initState();
    order = widget.order;
  }

  Color _getCardColor(String status) {
    switch (status) {
      case 'DIPESAN':
        return Colors.blue;
      case 'DIPROSES':
        return Colors.orange;
      case 'SELESAI':
        return Colors.green;
      default:
        return Colors.red;
    }
  }

  Future<void> _updateOrderStatus(String newStatus) async {
    try {
      // Fetch the data and handle the response
      final response = await fetchData(
        'order/edit_status_penjual/',
        method: RequestMethod.post,
        body: {
          'order_id': order.id,
          'order_status': newStatus,
        },
      );

      // Check the response for success status
      if (response['status'] == 'success') {
        setState(() {
          order.status = newStatus;
        });
      } else {
        // Handle specific error messages if available
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle errors such as network issues
      throw Exception('Failed to update order status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: _getCardColor(order.status),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${order.nama} (${order.quantity} pcs)',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Status: ${order.status}'),
            const Spacer(),
            ElevatedButton(
              onPressed: (order.status == 'SELESAI' || order.status == 'DIBATALKAN')
                  ? null
                  : () async {
                await _updateOrderStatus('SELESAI');
              },
              child: const Text('Selesaikan Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}
