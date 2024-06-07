// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'dart:convert';

List<Review> reviewFromJson(String str) => List<Review>.from(json.decode(str).map((x) => Review.fromJson(x)));

String reviewToJson(List<Review> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Review {
    dynamic nama;
    int nilai;
    String komentar;
    String reply;
    String namaMakanan;

    Review({
        required this.nama,
        required this.nilai,
        required this.komentar,
        required this.reply,
        required this.namaMakanan,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        nama: json["nama"],
        nilai: json["nilai"],
        komentar: json["komentar"],
        reply: json["reply"],
        namaMakanan: json["namaMakanan"],
    );

    Map<String, dynamic> toJson() => {
        "nama": nama,
        "nilai": nilai,
        "komentar": komentar,
        "reply": reply,
        "namaMakanan": namaMakanan,
    };
}
