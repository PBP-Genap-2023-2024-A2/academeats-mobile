import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_screen.dart';
import '../../auth/auth.dart';
import 'package:academeats_mobile/models/cart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();

    String? userRole = auth.user?.role;// TODO: Example role, replace with actual logic
    print('HomeScreen userRole: $userRole'); // Debug statement
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Container(
        child: Column(
          children: [
            OrderScreen(userRole: userRole ?? ""),
          ],
        )
      ),
    );
  }
}
