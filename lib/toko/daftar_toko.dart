import 'package:flutter/material.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:academeats_mobile/makanan/edit.dart' as edit;

import '../makanan/main_makanan.dart';
import '../models/toko.dart';
import 'toko_detail.dart';

<<<<<<< HEAD:lib/toko/daftar_toko.dart
class DaftarToko extends StatelessWidget {
  const DaftarToko({super.key});
=======
class TokoHomeScreen extends StatelessWidget {
  const TokoHomeScreen({super.key});
>>>>>>> main:lib/toko/home.dart

  @override
  Widget build(BuildContext context) {
    return const TestWidget();
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  _TestWidgetState createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  final TextEditingController _unameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toko'),
        backgroundColor: const Color(0xFFF6E049), // Primary color
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: fetchData('toko/api/v1/'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!['data'].isEmpty) {
                    return const Center(child: Text('No data available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!['data'].length,
                      itemBuilder: (context, index) {
                        Toko toko = Toko.fromJson(snapshot.data!['data'][index]);

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TokoDetailScreen(toko: toko),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF9DB), // Primary bg subtle
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFFBF3B6), // Primary border subtle
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Text(
                              toko.name,
                              style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                color: const Color(0xFF383A48), // Body color
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainMakananScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: const Color(0xFFE0719E), // Button text color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Semua Makanan'),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF3F6E6), // Body background color
    );
  }
}
