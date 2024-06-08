import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:academeats_mobile/review/models/review.dart';

class ReviewProvider with ChangeNotifier {
  List<Review> _reviews = [];

  List<Review> get reviews => _reviews;

  Future<void> fetchReviews(String tokoId) async {
    final response =
    await http.get(Uri.parse('http://localhost:8000/review/show_main_pembeli_json'));
    if (response.statusCode == 200) {
      // Print the response body (JSON data)
      print(response.body);
    } else {
      // If the request was not successful, print the error message
      print('Failed to fetch reviews: ${response.statusCode}');
    }
    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['reviews'];
      _reviews = jsonResponse
          .map((review) => Review.fromJson(review))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load reviews');
    }
  }
}