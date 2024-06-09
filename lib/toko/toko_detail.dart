import 'package:flutter/material.dart';
import '../makanan/detail_makanan.dart';
import '../makanan/tambah_makanan.dart';
import '../models/makanan.dart';
import '../models/toko.dart';
import '../utils/fetch.dart';

class TokoDetailScreen extends StatefulWidget {
  final Toko toko;

  TokoDetailScreen({required this.toko, Key? key}) : super(key: key);

  @override
  _TokoDetailScreenState createState() => _TokoDetailScreenState();
}

class _TokoDetailScreenState extends State<TokoDetailScreen> {
  late Future<Map<String, dynamic>> _makananFuture;

  @override
  void initState() {
    super.initState();
    _makananFuture = fetchData('makanan/api/v1/toko/${widget.toko.id}/');
  }

  void _refreshMakananList() {
    setState(() {
      _makananFuture = fetchData('makanan/api/v1/toko/${widget.toko.id}/');
    });
  }

  Future<void> _deleteMakanan(int makananId) async {
    // Send a delete request to the backend to delete the makanan
    final response = await deleteData('makanan/api/v1/delete/$makananId/');
    if (response['success']) {
      // If deletion is successful, refresh the makanan list
      _refreshMakananList();
    } else {
      // If deletion fails, show an error message
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(response['message']),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.toko.name),
        backgroundColor: const Color(0xFFF6E049),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _makananFuture,
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
                          image:
                          NetworkImage('https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.toko.name,
                      style: Theme.of(context).textTheme.headline5?.copyWith(
                        color: const Color(0xFF625A1D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Owner: ${widget.toko.user.namaLengkap}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: const Color(0xFF383A48),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Deskripsi: ${widget.toko.description}',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                        color: const Color(0xFF383A48),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final newMakanan = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                TambahMakananPage(toko: widget.toko),
                          ),
                        );
                        if (newMakanan != null) {
                          _refreshMakananList();
                        }
                      },
                      child: Text('Tambah Makanan'),
                    ),
                    const Divider(color: Color(0xFFE0719E)),
                    const SizedBox(height: 10),
                    Text(
                      'Available Makanan',
                      style: Theme.of(context).textTheme.headline6?.copyWith(
                        color: const Color(0xFFE0719E),
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
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFDF9DB),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFE0719E),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      FoodDetailScreen(makanan: makanan),
                                ),
                              );
                            },
                            child: Dismissible(
                              key: Key(makanan.id.toString()),
                              background: Container(
                                color: Colors.pink,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Detail',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              secondaryBackground: Container(
                                color: Colors.red,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              onDismissed: (direction) {
                                if (direction == DismissDirection.endToStart) {
                                  _deleteMakanan(makanan.id);
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          FoodDetailScreen(makanan: makanan),
                                    ),
                                  );
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    // Image widget to display the food image
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        makanan.imgUrl, // Use the image URL from your Makanan model
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 16), // Add spacing between the image and text
                                    // Text widgets for food details
                                    Expanded(
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
        },
      ),
      backgroundColor: const Color(0xFFF3F6E6),
    );
  }
}
