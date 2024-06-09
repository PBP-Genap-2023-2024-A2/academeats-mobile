import 'package:academeats_mobile/models/base_model.dart';

class Forum implements ISendable {
  int id;
  String judul;
  String deskripsi;
  DateTime dateAdded;

  Forum({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.dateAdded,
  });

  factory Forum.fromJson(Map<String, dynamic> json) => Forum(
    id: json["id"],
    judul: json["judul"],
    deskripsi: json["deskripsi"],
    dateAdded: DateTime.parse(json["created_at"]),
  );

  @override
  Map<String, dynamic> toJson() => {
    "id": id,
    "judul": judul,
    "deskripsi": deskripsi,
    "created_at": "${dateAdded.year.toString().padLeft(4, '0')}-${dateAdded.month.toString().padLeft(2, '0')}-${dateAdded.day.toString().padLeft(2, '0')}",
  };
}