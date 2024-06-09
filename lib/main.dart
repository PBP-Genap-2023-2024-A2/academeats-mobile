import 'package:academeats_mobile/pages/home.dart';
import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/review/create_review.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:academeats_mobile/pages/user/login.dart';

//Ngetes doang, nanti ganti lagi jadi home.dart

import 'package:academeats_mobile/models/cart.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AcademEats',
      theme: ThemeData(
        colorScheme: const ColorScheme(
            primary: Color.fromRGBO(246, 224, 73, 1),
            secondary: Color.fromRGBO(224, 113, 158, 1),
            surface: Colors.white60,
            background: Colors.white,
            brightness: Brightness.light,
            error: Color.fromRGBO(220, 53, 69, 1),
            onBackground: Colors.black87,
            onPrimary: Colors.black87,
            onSecondary: Colors.white70,
            onError: Colors.white,
            onSurface: Colors.black87),
      ),
      home: MultiProvider(
        providers: [
          Provider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => CartProvider()),
        ],

        child: const HomeScreen(),
      ),
    );
  }
}
