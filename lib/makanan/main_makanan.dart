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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Text(
              'New Dishes',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 200, // Adjust the height as needed
              child: FutureBuilder<Map<String, dynamic>>(
                future: fetchData('makanan/api/v1/'),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    print('Error: ${snapshot.error}');
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data == null) {
                    print('No data found');
                    return Center(child: Text('No data found'));
                  } else {
                    List<dynamic> makananList = snapshot.data!['data'];

                    // Sort the makananList by ID in descending order
                    makananList.sort((a, b) => b['id'].compareTo(a['id']));

                    List<Makanan> previewMakanans = [];

                    // Take the latest 10 makanan items
                    int previewItemCount = makananList.length > 20 ? 20 : makananList.length;

                    for (var i = 0; i < previewItemCount; i++) {
                      Makanan makanan = Makanan.fromJson(makananList[i]);
                      previewMakanans.add(makanan);
                    }

                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: previewMakanans.map((makanan) {
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
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              padding: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(color: const Color(0xFFE0719E)),
                                image: DecorationImage(
                                  image: NetworkImage(makanan.imgUrl), // Provide the image URL
                                  fit: BoxFit.cover,
                                ),
                              ),
                              width: 150, // Adjust the width as needed
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.5),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(15),
                                        bottomRight: Radius.circular(15),
                                      ),
                                    ),
                                    child: Text(
                                      makanan.nama,
                                      style: Theme.of(context).textTheme.headline6?.copyWith(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'All Makanan',
              style: Theme.of(context).textTheme.headline5,
            ),
            FutureBuilder<Map<String, dynamic>>(
              future: fetchData('makanan/api/v1/'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  print('Error: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data == null) {
                  print('No data found');
                  return Center(child: Text('No data found'));
                } else {
                  List<dynamic> makananList = snapshot.data!['data'];
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: makananList.length,
                    itemBuilder: (_, index) {
                      Makanan makanan = Makanan.fromJson(makananList[index]);
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
                          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          padding: const EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF9DB),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: const Color(0xFFE0719E)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 100, // Adjust the width as needed
                                height: 100, // Adjust the height as needed
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image: NetworkImage(makanan.imgUrl), // Provide the image URL
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
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
                                  ],
                                ),
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
          ],
        ),
      ),
    );
  }
}
