import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:academeats_mobile/review/models/review.dart';

class ReviewPage extends StatefulWidget {
    const ReviewPage({Key? key}) : super(key: key);

    @override
    State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
Future<List<Review>> fetchReview() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    var url = Uri.parse(
        'http://localhost:8000/json/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Review
    List<Review> listReview = [];
    for (var d in data) {
        if (d != null) {
            listReview.add(Review.fromJson(d));
        }
    }
    return listReview;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Review'),
        ),
        body: FutureBuilder(
            future: fetchReview(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                        return const Column(
                            children: [
                                Text(
                                    "Tidak ada data buku.",
                                    style: TextStyle(
                                        color: Color(0xff59A5D8),
                                        fontSize: 20
                                    ),
                                ),
                                SizedBox(height: 8),
                            ],
                        );
                    } else {
                        return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12
                                ),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Text(
                                            "${snapshot.data![index].fields.nama}",
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text("${snapshot.data![index].fields.nilai}"),
                                        const SizedBox(height: 10),
                                        Text("${snapshot.data![index].fields.komentar}")
                                    ],
                                ),
                            ),
                        );
                    }
                }
            }),
        );
    }
}