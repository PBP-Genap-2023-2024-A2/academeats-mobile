import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class Order {
  final int pk;
  final String nama;
  final int quantity;
  String status;

  Order({required this.pk, required this.nama, required this.quantity, required this.status});
}

// Notify its listeners when its internal state changes.
class OrderProvider with ChangeNotifier {
  // List of orders
  // TODO: fetch the orders generated
  final List<Order> _orders = [
    Order(pk: 1, nama: 'Makanan 1', quantity: 2, status: 'DIPESAN'),
    Order(pk: 2, nama: 'Makanan 2', quantity: 1, status: 'DIPROSES'),
  ];

  // A getter method orders to retrieve the list of orders
  List<Order> get orders => _orders;

  // Method to update the status of an order asynchronously
  Future<void> updateOrderStatus(int pk, String newStatus) async {
    // TODO: simulate a network request
    await Future.delayed(const Duration(seconds: 1));

    // Find the order and update its status
    final order = _orders.firstWhere((order) => order.pk == pk);
    order.status = newStatus;
    notifyListeners();
  }
}

class OrderScreen extends StatelessWidget {
  final String userRole;

  const OrderScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    if (userRole == 'Penjual') {
      return const OrderScreenForPenjual();
    } else if (userRole == 'Pembeli') {
      // TODO: replace this with actual orderGroup fetching logic
      final orderGroup = [
        {
          'pk': 1,
          'user': 'User 1',
          'orders': [
            {'makanan': {'nama': 'Makanan 1'}, 'toko': '1', 'quantity': 2, 'status': 'DIPESAN'},
            {'makanan': {'nama': 'Makanan 2'}, 'toko': '2', 'quantity': 3, 'status': 'DIPESAN'},
          ],
          'total_harga': 50000,
          'status': 'DIPESAN',
        },
        {
          'pk': 2,
          'user': 'User 1',
          'orders': [
            {'makanan': {'nama': 'Makanan 2'}, 'toko': '2', 'quantity': 3, 'status': 'DIPESAN'},
          ],
          'total_harga': 150000,
          'status': 'DIPESAN',
        },
      ];
      return OrderPembeliScreen(orderGroup: orderGroup);
    } else {
      return const Scaffold(body: Center(child: Text('Unknown user role')));
    }
  }
}


class OrderScreenForPenjual extends StatelessWidget {
  const OrderScreenForPenjual({super.key});

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


class OrderPembeliScreen extends StatelessWidget {
  final List<Map<String, dynamic>> orderGroup;

  const OrderPembeliScreen({super.key, required this.orderGroup});

  @override
  Widget build(BuildContext context) {
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
            return _buildOrderGroupCard(og);
          },
        ),
      ),
    );
  }

  Widget _buildOrderGroupCard(Map<String, dynamic> og) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Order ID: ${og['pk']}'),
                Text(og['user']),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: og['orders'].length,
            itemBuilder: (context, index) {
              final order = og['orders'][index];
              return _buildOrderCard(order);
            },
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('TOTAL'),
                    Text('Rp${og['total_harga']}'),
                  ],
                ),
                const Divider(color: Colors.brown),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Status Pesanan:'),
                    Text(og['status']),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: handle cancel order button press
                    // You can implement the logic here
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

  Widget _buildOrderCard(Map<String, dynamic> order) {
    return Card(
      child: ListTile(
        title: Text(order['makanan']['nama']),
        subtitle: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Toko ${order['toko']}'),
            Text('Jumlah: ${order['quantity']}'),
          ],
        ),
        trailing: order['status'] == 'SELESAI'
            ? ElevatedButton(
          onPressed: () {
            // TODO: Handle review button press
            // You can implement the logic here
          },
          child: const Text('Review'),
        )
            : null,
      ),
    );
  }
}


class OrderCard extends StatelessWidget {
  final Order order;

  const OrderCard({super.key, required this.order});

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
              // If the order status is SELESAI, the onPressed property is set to null, and the button is disabled
              // TODO: Integrate this with Django function to change the order status
              onPressed: order.status == 'SELESAI'
                  ? null
                  : () async {
                // If the order status is not SELESAI, it will execute these lines
                // If the order status is DIPESAN, it will be changed to DIPROSES, otherwise, it will be changed to SELESAI
                final newStatus = order.status == 'DIPESAN' ? 'DIPROSES' : 'SELESAI';
                // Updating the order status by calling the method updateOrderStatus
                await orderProvider.updateOrderStatus(order.pk, newStatus);
              },
              child: Text(order.status == 'DIPESAN' ? 'Proses Pesanan' : 'Selesaikan Pesanan'),
            ),
          ],
        ),
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace this with actual user role fetching logic
    String userRole = 'Pembeli'; // or 'Pembeli'
    // Constructing OrderScreen object
    return OrderScreen(userRole: userRole);
  }
}
