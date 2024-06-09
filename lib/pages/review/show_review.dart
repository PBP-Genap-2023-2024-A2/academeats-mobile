import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/toko.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/pages/review/create_review.dart';
import 'package:academeats_mobile/pages/review/reply_review.dart';
import 'package:academeats_mobile/pages/user/login.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';

import '../../models/review.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ReviewFormPage(makanans: Makanan(id: 2, nama: "pempek", harga: 3000, stok: 2, imgUrl: "", toko: Toko(id: 1, user: User (bio: "", id: 0, username: '', namaLengkap: '', namaPanggilan: '', role: 'penjual'), name: "Jl. Pempek", description: "Pempek Palembang")));
  }
}

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review?>> futureReviews;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews();
  }

  void _onItemTapped(int index) {
        setState(() {
          _selectedIndex = index;
        });
  }

  Future<List<Review?>> fetchReviews() async {
    var response = await fetchData('review/api/v1/');

    if (response.containsKey('data')) {
      List<dynamic> data = response['data'];

      List<Review?> listReview = data.map((d) {
        if (d != null) {
          return Review.fromJson(d as Map<String, dynamic>);
        } else {
          return null; // Handle null case
        }
      }).where((review) => review != null).toList();

      return listReview;
    } else {
      throw Exception('Unexpected response format');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Toko',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped, 
      ),
      body: FutureBuilder<List<Review?>>(
        future: futureReviews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Review?> reviews = snapshot.data!;
            return ListView.builder(
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                Review? review = reviews[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.all(8),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Nilai: ${review?.nilai}'),
                        const SizedBox(height: 4),
                        Text('Komentar: ${review?.komentar}'),
                        const SizedBox(height: 4),
                        if (review?.reply != null) ...[
                          Text('Reply: ${review?.reply}'),
                        ] else ...[
                          const Text('Reply: (Belum ada balasan)'),
                          ElevatedButton(
                            onPressed: () {
                              // Tambahkan aksi ketika tombol ditekan
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReplyFormPage(reviews: review)));
                            },
                            child: const Text('Reply Review'),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No reviews found.'));
          }
        },
      ),
    );
    
  }
}