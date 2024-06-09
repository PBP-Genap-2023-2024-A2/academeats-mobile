import 'package:flutter/material.dart';
import 'package:academeats_mobile/auth/auth.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:academeats_mobile/models/cart.dart';
import 'package:academeats_mobile/models/user.dart';

// Import DaftarToko screen
import '../makanan/main_makanan.dart';
import '../toko/daftar_toko.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentPageIndex = 0;

  final List<Widget> _pageList = <Widget>[
    const MainScreen(),
  ];

  @override
  void initState() {
    super.initState();

    User? user = Provider.of<AuthProvider>(context, listen: false).user;

    // Get initial state for cart and user
    if (user != null) {
      Provider.of<CartProvider>(context, listen: false).fetchCart(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_filled), label: "Home"),
          NavigationDestination(icon: Icon(Icons.home_filled), label: "Home"),
        ],
      ),
      body: _pageList[_currentPageIndex],
    );
  }
}
