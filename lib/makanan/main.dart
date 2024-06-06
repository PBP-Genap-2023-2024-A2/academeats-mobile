import 'package:flutter/material.dart';
import 'detail.dart';
import 'edit.dart';
// import 'makanan/tambah.dart'; // Import the EditMakananPage widget
// import 'makanan/detail.dart'; // Import the DetailMakananPage widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
      routes: {
        '/edit': (context) => EditMakananPage(), // Define the route for the EditMakananPage
        // '/detail': (context) => DetailMakananPage(), // Define the route for the DetailMakananPage
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit'); // Navigate to the EditMakananPage
              },
              child: Text('Go to Edit Makanan Page'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/detail'); // Navigate to the DetailMakananPage
              },
              child: Text('Go to Detail Makanan Page'),
            ),
          ],
        ),
      ),
    );
  }
}
