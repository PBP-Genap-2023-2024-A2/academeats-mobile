import 'package:academeats_mobile/models/makanan.dart';
import 'package:flutter/material.dart';
import 'makanan/detail.dart';
import 'makanan/tambah.dart';
import 'models/toko.dart'; // Import the EditMakananPage widget

void main() {
  runApp(MyApp());
}
//
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes:{
        '/edit':(context) => EditMakananPage(),
        '/tambah': (context) =>
      } ,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

// class HomePage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return DetailMakananScreen(
//       Makanan(pk: 1, nama: "Budi", harga: 10000,stok: 10,imgUrl: "")
//     );
//   }
// }
//
// class DetailMakananScreen extends StatelessWidget {
//   final Makanan makanan;
//
//   const DetailMakananScreen(this.makanan, {super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         Text(makanan.nama),
//         Text(makanan.harga.toString()),
//       ],
//     );
//   }
//
//
// }

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
                Navigator.pushNamed(context, '/detail'); // Navigate to the MakananPage
              },
              child: Text('Go to Makanan Page'),
            ),
          ],
        ),
      ),
    );
  }
}
