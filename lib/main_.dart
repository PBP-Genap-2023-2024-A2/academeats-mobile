import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../order/providers/order_provider.dart';
import '../../models/order_group.dart';
import '../../models/order.dart';
import '../order/screens/order_screen.dart';
import '../order/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: MaterialApp(
        title: 'Order Management App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For the purpose of this example, we'll use a hardcoded user role.
    // In a real application, you might fetch this from a backend or user preferences.
    String userRole = 'Penjual'; // or 'Pembeli'

    return OrderScreen(userRole: userRole);
  }
}
