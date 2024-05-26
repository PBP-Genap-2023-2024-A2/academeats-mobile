import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_screen_for_penjual.dart';
import 'order_pembeli_screen.dart';

class OrderScreen extends StatelessWidget {
  final String userRole;

  const OrderScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userRole == 'Penjual') {
      return const OrderScreenForPenjual();
    } else if (userRole == 'Pembeli') {
      return Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          return OrderPembeliScreen(orderGroup: orderProvider.orderGroups);
        },
      );
    } else {
      return const Scaffold(body: Center(child: Text('Unknown user role')));
    }
  }
}
