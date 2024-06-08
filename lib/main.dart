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
        title: 'AcademEats',
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
    // TODO: fetch user's role
    String userRole = 'Penjual'; // or 'Pembeli'

    return OrderScreen(userRole: userRole);
  }
}
