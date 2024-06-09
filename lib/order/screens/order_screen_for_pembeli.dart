import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import '../../models/order_group.dart';
import '../../models/order.dart';

class OrderScreenForPembeli extends StatefulWidget {
  final int ogId;

  OrderScreenForPembeli(this.ogId, {super.key});

  @override
  _OrderScreenForPembeliState createState() => _OrderScreenForPembeliState();
}

class _OrderScreenForPembeliState extends State<OrderScreenForPembeli> {
  late Future<Map<String, dynamic>> _orderData;

  @override
  void initState() {
    super.initState();
    _fetchOrderData();
  }

  void _fetchOrderData() {
    setState(() {
      _orderData = fetchData('order/api/v1/order_group/${widget.ogId}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
      ),
      body: FutureBuilder(
        future: _orderData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orderGroup = OrderGroup.fromJson(snapshot.data!['og']);
            List<Order> orders = [];
            String orderStatus = snapshot.data!['status'];
            for (int i = 0; i < snapshot.data!['orders'].length; i++) {
              Order order = Order.fromJson(snapshot.data!['orders'][i]);
              orders.add(order);
            }

            return OrderGroupCard(
              orderGroup: orderGroup,
              orders: orders,
              orderStatus: orderStatus,
              onOrderCanceled: _fetchOrderData,
            );
          }
        },
      ),
    );
  }
}

class OrderGroupCard extends StatelessWidget {
  final OrderGroup orderGroup;
  final List<Order> orders;
  final String orderStatus;
  final VoidCallback onOrderCanceled;

  OrderGroupCard({
    required this.orderGroup,
    required this.orders,
    required this.orderStatus,
    required this.onOrderCanceled,
  });

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
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
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
                    Text(orderStatus),
                  ],
                ),
                ElevatedButton(
                  onPressed: (orderStatus == 'DIBATALKAN')
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
        for (Order order in og.orders) {
          order.status = "DIBATALKAN";
        }
        // Optionally, notify listeners or update the UI
      } else {
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle errors such as network issues
      throw Exception('Failed to update order status: $e');
    }
  }
}
