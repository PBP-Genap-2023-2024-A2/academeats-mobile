// To parse this JSON data, do
//
//     final review = reviewFromJson(jsonString);

import 'package:academeats_mobile/models/base_model.dart';
import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/user.dart';

class Review implements ISendable{
    int id;
    int nilai;
    String komentar;
    String? reply;
    User? user;
    Makanan? makanan;

    Review({
        required this.id,
        required this.nilai,
        required this.komentar,
        required this.reply,
        required this.user,
        required this.makanan,
    });

    factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'],
        nilai: json['nilai'],
        komentar: json['komentar'],
        reply: json['reply'],
        user: json['user'] != null ? User.fromJson(json['user']) : null,
        makanan: json['makanan'] != null ? Makanan.fromJson(json['makanan']) : null,
    );

    @override
      Map<String, dynamic> toJson() => {
        "id": id,
        "nilai": nilai,
        "komentar": komentar,
        "reply": reply,
        "user": user?.toJson(),
        "makanan": makanan?.toJson(),
    };
}
