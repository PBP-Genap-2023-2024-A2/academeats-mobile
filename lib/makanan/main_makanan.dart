import 'package:flutter/material.dart';
import 'package:academeats_mobile/makanan/detail_makanan.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import '../models/makanan.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TestWidget();
  }
}

class TestWidget extends StatefulWidget {
  const TestWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food'),
        backgroundColor: const Color(0xFFF6E049),
      ),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchData('makanan/api/v1/'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    print('No data found');
                    return const Center(child: Text('No data found'));
                  } else {
                    List<dynamic> makananList = snapshot.data!['data'];
                    return ListView.builder(
                      itemCount: makananList.length,
                      itemBuilder: (_, index) {
                        Makanan makanan = Makanan.fromJson(makananList[index]);

                        return GestureDetector(
                          onTap: () {
                            // Navigate to FoodDetailScreen and pass the id of the selected food item
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FoodDetailScreen(makanan: makanan),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFDF9DB),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: const Color(0xFFE0719E)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  makanan.nama,
                                  style: Theme.of(context).textTheme.headline6?.copyWith(color: const Color(0xFF625A1D)),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Harga: ${makanan.harga}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Stok: ${makanan.stok}',
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  'Toko: ${makanan.toko.name}',
                                  style: Theme.of(context).textTheme.bodyText2?.copyWith(color: const Color(0xFF5A2D3F)),
                                ),
                                const SizedBox(height: 5),
                                Container(
                                  height: 5,
                                  width: double.infinity,
                                  color: const Color(0xFFE0719E),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
