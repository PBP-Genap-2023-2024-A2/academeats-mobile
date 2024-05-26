import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import '../models/order_group.dart';
import '../models/order.dart';

class OrderPembeliScreen extends StatelessWidget {
  const OrderPembeliScreen({super.key, required this.orderGroup});
  final List<OrderGroup> orderGroup;

  @override
  Widget build(BuildContext context) {
    print('OrderGroup data: $orderGroup');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: orderGroup.length,
          itemBuilder: (context, index) {
            final og = orderGroup[index];
            return _buildOrderGroupCard(og, context);
          },
        ),
      ),
    );
  }

  Widget _buildOrderGroupCard(OrderGroup og, BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${og.pk}'),
                Text('Total: Rp${og.totalHarga}'),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: og.orders.length,
            itemBuilder: (context, index) {
              final order = og.orders[index];
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
                    Text(og.status),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<OrderProvider>(context, listen: false).cancelOrder(og.pk);
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
