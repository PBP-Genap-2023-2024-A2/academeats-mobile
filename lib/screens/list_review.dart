import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:academeats_mobile/forms/models/review.dart';

class BookPage extends StatefulWidget {
    const BookPage({Key? key}) : super(key: key);

    @override
    State<BookPage> createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
Future<List<Review>> fetchBook() async {
    var url = Uri.parse(
        'http://localhost:8000/review/show-review-json/<id_makanan>/');
    var response = await http.get(
        url,
        headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Book
    List<Review> listBook = [];
    for (var d in data) {
        if (d != null) {
            listBook.add(Review.fromJson(d));
        }
    }
    return listBook;
}

@override
Widget build(BuildContext context) {
    return Scaffold(
      // TODO: ganti field title dengan nama makanan
        appBar: AppBar(
            title: const Text('Review Makanan <nama_makanan>'),
        ),
        body: FutureBuilder(
            future: fetchBook(),
            builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                        return const Column(
                            children: [
                                Text(
                                    "Tidak ada review.",
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
                                            "${snapshot.data![index].fields.name}",
                                            style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                            ),
                                        ),
                                        const SizedBox(height: 10),
                                        Text("${snapshot.data![index].fields.page}"),
                                        const SizedBox(height: 10),
                                        Text("${snapshot.data![index].fields.description}")
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