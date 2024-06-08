import 'package:flutter/material.dart';
import '../makanan/detail_makanan.dart';
import '../models/makanan.dart'; // Adjust the import path accordingly
import 'package:academeats_mobile/utils/fetch.dart';
import '../models/toko.dart';

class TokoDetailScreen extends StatelessWidget {
  final Toko toko; // Define a property to hold the Toko object

  TokoDetailScreen({required this.toko, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(toko.name), // Display the toko's name as the title
        backgroundColor: const Color(0xFFF6E049), // Primary color
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchData('makanan/api/v1/toko/${toko.id}/'),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            Map<String, dynamic>? data = snapshot.data;
            if (data == null || data['data'] == null) {
              return const Center(child: Text('No data found'));
            }

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      toko.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: const Color(0xFF625A1D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Owner: ${toko.user.namaLengkap}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: const Color(0xFF383A48),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Deskripsi: ${toko.description}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: const Color(0xFF383A48),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Divider(color: Color(0xFFE0719E)), // Pink divider
                    const SizedBox(height: 10),
                    Text(
                      'Available Makanan',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: const Color(0xFFE0719E), // Pink text color
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: data['data'].length,
                      itemBuilder: (context, index) {
                        Makanan makanan = Makanan.fromJson(data['data'][index]);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailScreen(makanan: makanan),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            padding: const EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF9DB),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFE0719E), // Pink border
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  makanan.nama,
                                  style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: const Color(0xFF383A48),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Harga: ${makanan.harga}',
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: const Color(0xFF383A48),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Stok: ${makanan.stok}',
                                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                                    color: const Color(0xFF383A48),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
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
