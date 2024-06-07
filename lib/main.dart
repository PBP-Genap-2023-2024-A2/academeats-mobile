import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
//import 'package:academeats_mobile/pages/home.dart';

//Ngetes doang, nanti ganti lagi jadi home.dart
import 'package:academeats_mobile/pages/review/show_review.dart';
import 'package:academeats_mobile/pages/review/reply_review.dart';

import 'package:academeats_mobile/models/cart.dart';

void main() {
  runApp(const MaterialApp(
    title: 'AcademEats',
    home: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
    const MainApp({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            },
            child: MaterialApp(
                title: 'Flutter App',
                theme: ThemeData(
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
                    useMaterial3: true,
                ),
                home: const HomeScreen(),
            ),
        );
    }
}