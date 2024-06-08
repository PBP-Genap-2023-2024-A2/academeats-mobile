import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order_screen.dart';
import 'package://academeats_mobile/auth/auth.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();
    String userRole = 'Pembeli'; // TODO: Example role, replace with actual logic
    print('HomeScreen userRole: $userRole'); // Debug statement
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: OrderScreen(userRole: userRole),
      ),
    );
  }
}
