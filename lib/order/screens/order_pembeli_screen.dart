import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../../models/order_group.dart';
import '../../models/order.dart';

@override
class OrderScreenForPembeli extends StatelessWidget {
  final int ogId;

  OrderScreenForPembeli(this.ogId, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return FutureBuilder(
            future: fetchData('order/api/v1/order_group/$ogId'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                final orderGroup = OrderGroup.fromJson(snapshot.data!['data']);
                return OrderGroupCard(
                  orderGroup: orderGroup,
                  onCancel: (og) => orderProvider.cancelOrder(og),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class OrderGroupCard extends StatelessWidget {
  final OrderGroup orderGroup;
  final Future<void> Function(OrderGroup) onCancel;

  OrderGroupCard({required this.orderGroup, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
            itemCount: orderGroup.orders.length,
            itemBuilder: (context, index) {
              final order = orderGroup.orders[index];
              return _buildOrderCard(order);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
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
                  onPressed: () async {
                    await onCancel(orderGroup);
                  },
                  child: const Text('Batalkan Pesanan'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Order order) {
    return Card(
      child: ListTile(
        title: Text(order.nama),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Jumlah: ${order.quantity}'),
            Text('Status: ${order.status}'),
          ],
        ),
      ),
    );
  }
}

