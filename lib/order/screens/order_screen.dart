import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/order/screens/toko_screen_for_penjual.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_screen_for_penjual.dart';
import 'order_screen_for_pembeli.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    String userRole = user?.role ?? "";

    print('OrderScreen userRole: $userRole'); // Debug statement
    if (userRole == 'penjual') {
      // TODO: get the actual tokoId
      final int tokoId = 1;
      return TokoScreenForPenjual();
    } else if (userRole == 'pembeli') {
      // TODO: get the actual ogId
      final int ogId = 1;
      return OrderScreenForPembeli();
    } else {
      return const Scaffold(
        body: Center(child: Text('Unknown user role')),
      );
    }
  }
}
