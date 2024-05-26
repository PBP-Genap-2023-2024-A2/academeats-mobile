import 'package:academeats_mobile/forms/models/review.dart';
import 'package:academeats_mobile/menu.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
 // Import the menu.dart file

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Academeats',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Academeats'),
    );
  }
}

class ReviewPage extends StatelessWidget {
  final String makananNama = "Example Food"; // Replace with your dynamic data
  final bool isToko = true; // Replace with your dynamic data

  final List<Review> reviews = [
    Review(nama: "User1", nilai: 4, komentar: "Great taste!", reply: "Thank you!"),
    Review(user: "User2", nilai: 5, komentar: "Excellent!", reply: null),
    Review(user: "User3", nilai: 3, komentar: "Not bad", reply: "We will improve."),
    // Add more reviews as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review $makananNama'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            return ReviewCard(review: reviews[index], isToko: isToko);
          },
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final Review review;
  final bool isToko;

  ReviewCard({required this.review, required this.isToko});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              review.user,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Rating: ${review.nilai}',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < review.nilai ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 24,
                );
              }),
            ),
            SizedBox(height: 10),
            Text(
              'Komentar: ${review.komentar}',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            if (review.reply != null)
              Text(
                'Reply: ${review.reply}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Penjual belum memberikan balasan',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  if (isToko)
                    TextButton(
                      onPressed: () {
                        // Navigate to reply screen
                      },
                      child: Text('Balas'),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

