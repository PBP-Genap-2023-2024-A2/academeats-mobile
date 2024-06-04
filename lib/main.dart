import 'package:academeats_mobile/forms/models/review.dart';
import 'package:academeats_mobile/menu.dart';
import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'order/menu.dart';  // Import the menu.dart file

void main() {
  runApp(const MaterialApp(
    title: 'AcademEats',
    home: MainApp(),
  ));
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
      home: const HomeScreen(),
    );
  }
}