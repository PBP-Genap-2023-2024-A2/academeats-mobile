import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:academeats_mobile/models/toko.dart';
import 'package:provider/provider.dart';
import '../../auth/auth.dart';
import '../../keranjang/keranjang_screen.dart';
import '../../utils/fetch.dart';
import 'order_screen_for_penjual.dart'; // Import your OrderScreenForPenjual here

class TokoScreenForPenjual extends StatelessWidget {

  TokoScreenForPenjual({super.key});

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = context.watch<AuthProvider>();
    String username = auth.user?.username ?? "";
    return Scaffold(
      appBar: AppBar(
          title: const Text('Daftar Tokomu'),
      ),
      body: FutureBuilder(
        future: fetchData('toko/api/v1/user/$username/'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: snapshot.data!['data'].length,
              itemBuilder: (context, index) {
                final toko = Toko.fromJson(snapshot.data!['data'][index]);
                return TokoCard(toko: toko);
              },
            );
          }
        },
      ),
    );
  }
}

class TokoCard extends StatelessWidget {
  final Toko toko;

  const TokoCard({Key? key, required this.toko}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              toko.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${toko.description}'),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OrderScreenForPenjual(toko.id),
                  ),
                );
              },
              child: const Text('See Orders'),
            ),
          ],
        ),
      ),
    );
  }
}
