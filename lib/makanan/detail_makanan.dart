import 'package:flutter/material.dart';
import '../models/makanan.dart'; // Adjust the import path accordingly
import 'package:academeats_mobile/utils/fetch.dart';

import '../toko/toko_detail.dart';

class FoodDetailScreen extends StatelessWidget {
  final Makanan makanan; // Define a property to hold the Makanan object

  FoodDetailScreen({required this.makanan, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(makanan.nama),
        backgroundColor: const Color(0xFFF6E049), // Primary color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData('makanan/api/v1/${makanan.id}'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            Map<String, dynamic>? data = snapshot.data;
            if (data == null) {
              return const Center(child: Text('No data found'));
            }

            Makanan fetchedMakanan = Makanan.fromJson(data);

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the makanan image using the img_url
                    Container(
                      height: 400, // Make the image taller
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0719E),
                        // Pink color
                        borderRadius: BorderRadius.circular(20),
                        // Larger border radius for a more squared look
                        image: DecorationImage(
                          image: NetworkImage(fetchedMakanan.imgUrl ??
                              'https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      fetchedMakanan.nama,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                            color: const Color(0xFF625A1D),
                            // Primary text emphasis color
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Harga: ${fetchedMakanan.harga}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: const Color(0xFF383A48), // Body color
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Stok: ${fetchedMakanan.stok}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: const Color(0xFF383A48), // Body color
                          ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => TokoDetailScreen(toko: fetchedMakanan.toko) ));
                      },
                      child: Text(
                        'Toko: ${fetchedMakanan.toko.name}',
                        style: Theme.of(context).textTheme.subtitle2?.copyWith(
                              color: const Color(
                                  0xFF5A2D3F), // Secondary text emphasis color
                            ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFFF3F6E6), // Body background color
    );
  }
}
