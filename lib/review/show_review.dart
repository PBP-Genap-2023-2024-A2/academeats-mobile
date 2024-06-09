import 'package:academeats_mobile/auth/auth.dart';
import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/toko.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/review/create_review.dart';
import 'package:academeats_mobile/review/reply_review.dart';
import 'package:academeats_mobile/pages/user/login.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../keranjang/keranjang_screen.dart';
import '../models/review.dart';
class ReviewPage extends StatefulWidget {
  final Makanan? makanans;
  const ReviewPage({super.key, required this.makanans});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review?>> futureReviews;

  @override
  void initState() {
    super.initState();
    futureReviews = fetchReviews();
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
    final request = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews'),
          actions: [
            IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => KeranjangScreen(),
                  ),
                );
              },
            ),
          ]
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
            List<Review?> filteredReviews = reviews.where((review) => review?.makanan?.id == widget.makanans?.id).toList();
            if (filteredReviews.isEmpty) {
              return const Center(child: Text('No reviews found.'));
            }
            return ListView.builder(
              
              itemCount: reviews.length,
              itemBuilder: (context, index) {
                Review? review = reviews[index];
                if (review?.makanan!.nama == widget.makanans!.nama) {
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
                              if (review?.makanan?.toko.user == request.user) ...[
                                ElevatedButton(
                                  onPressed: () {
                                  // Tambahkan aksi ketika tombol ditekan
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ReplyFormPage(reviews: review)));
                                  },
                                  child: const Text('Reply Review'),
                                ),
                              ]
                          ],
                        ],
                      ),
                    ),
                  );
                } else {
                    return SizedBox.shrink();
                }
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