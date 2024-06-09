import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/forum/forum_home.dart';
import 'package:academeats_mobile/makanan/main_makanan.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:academeats_mobile/models/cart.dart';
import 'package:academeats_mobile/models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int _currentPageIndex = 0;

  final List<Widget> _pageList = <Widget>[
    const MainMakananScreen(),
    const ForumHomePage(),
    // const TrackOrder(),
    // const Profile(),
  ];

  @override
  void initState() {
    super.initState();

    User? user = Provider
        .of<AuthProvider>(context, listen: false)
        .user;

    // Get initial state for cart and user
    if (user != null) {
      Provider
          .of<CartProvider>(context, listen: false)
          .fetchCart(user);
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
          NavigationDestination(icon: Icon(Icons.home_filled), label: "Home",),
<<<<<<< HEAD
          NavigationDestination(icon: Icon(Icons.home_filled), label: "Home",),
=======
          NavigationDestination(icon: Icon(Icons.shop), label: "Toko",),
          NavigationDestination(icon: Icon(Icons.history), label: "Order",),
          NavigationDestination(icon: Icon(Icons.person_rounded), label: "Profile")
>>>>>>> main
        ],
      ),
      body: _pageList[_currentPageIndex],
    );
  }
}

class MainScreen extends StatelessWidget {

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = context.watch<AuthProvider>().user;

    return Container(
      padding: EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text("Username pengguna: ${user?.username}")
          ],
        ),
      ),
    );
  }
}

