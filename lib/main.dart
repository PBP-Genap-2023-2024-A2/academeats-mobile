import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:academeats_mobile/pages/home.dart';

import 'package:academeats_mobile/models/cart.dart';

void main() {
  runApp(const MaterialApp(
    title: 'AcademEats',
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => CookieRequest()),
        ChangeNotifierProvider(
            create: (_) => Cart()
        )
      ],
      child: const HomeScreen(),
    );
  }
}