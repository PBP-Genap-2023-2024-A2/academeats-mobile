import 'package:flutter/material.dart';

import 'tambah.dart';

class MakananHome extends StatelessWidget {
  const MakananHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text('Makanan Home'),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Add navigation or action here
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Add navigation or action here
                },
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Text('Welcome to Makanan Home!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditMakananPage()),
          );
        },
        child: Icon(Icons.edit),
      ),
    );
  }
}
