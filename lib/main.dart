import 'package:academeats_mobile/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'order/menu.dart';  // Import the menu.dart file

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Academeats'),
    );
  }
}

