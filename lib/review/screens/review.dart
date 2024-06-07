import 'package:flutter/material.dart';


class ReviewScreen extends StatelessWidget {
  final String userRole;

  const ReviewScreen({Key? key, required this.userRole}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (userRole == 'Penjual') {
      return const Scaffold(body: Center(child: Text('Ini adalah penjual')));
    } else if (userRole == 'Pembeli') {
      return const Scaffold(body: Center(child: Text('Ini adalah pembeli')));
    } else {
      return const Scaffold(body: Center(child: Text('Unknown user role')));
    }
  }
}
