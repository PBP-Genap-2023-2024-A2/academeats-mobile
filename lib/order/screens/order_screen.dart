import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/order_provider.dart';
import 'order_penjual_screen.dart';
import 'order_pembeli_screen.dart';

class OrderScreen extends StatelessWidget {
  final String userRole;

  const OrderScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<OrderProvider>(
      builder: (context, orderProvider, child) {
        print(userRole);
        if (userRole == 'Penjual') {
          // TODO: get the actual tokoId
          final int tokoId = 1;
          return OrderScreenForPenjual(tokoId);
        } else if (userRole == 'Pembeli') {
          // TODO: get the actual ogId
          final int ogId = 1;
          return OrderScreenForPembeli(ogId);
        } else {
          return const Scaffold(
            body: Center(child: Text('Unknown user role')),
          );
        }
      },
    );
  }
}
