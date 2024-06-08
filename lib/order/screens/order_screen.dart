import 'package:flutter/material.dart';
import 'order_screen_for_penjual.dart';
import 'order_screen_for_pembeli.dart';

class OrderScreen extends StatelessWidget {
  final String userRole;

  const OrderScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('OrderScreen userRole: $userRole'); // Debug statement
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
  }
}
