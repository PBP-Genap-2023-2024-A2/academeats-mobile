import 'package:flutter/material.dart';
import 'makanan/edit.dart'; // Import the EditMakananPage widget

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
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/edit'); // Navigate to the EditMakananPage
          },
          child: Text('Go to Edit Makanan Page'),
        ),
      ),
    );
  }
}
