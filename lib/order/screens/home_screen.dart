import 'package:flutter/material.dart';
import 'order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String userRole = 'Pembeli'; // TODO: Example role, replace with actual logic
    return OrderScreen(userRole: userRole);
  }
}
