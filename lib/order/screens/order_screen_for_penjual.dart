import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order.dart';

class OrderScreenForPenjual extends StatelessWidget {
  const OrderScreenForPenjual({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
            ),
            itemCount: orderProvider.orders.length,
            itemBuilder: (context, index) {
              final order = orderProvider.orders[index];
              return OrderCard(order: order);
            },
          );
        },
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({Key? key, required this.order}) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context, listen: false);

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
              onPressed: order.status == 'SELESAI'
                  ? null
                  : () async {
                final newStatus =
                order.status == 'DIPESAN' ? 'DIPROSES' : 'SELESAI';
                await orderProvider.updateOrderStatus(order.pk, newStatus);
              },
              child: Text(order.status == 'DIPESAN'
                  ? 'Proses Pesanan'
                  : 'Selesaikan Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}
