import 'package:academeats_mobile/models/base_model.dart';
import 'package:academeats_mobile/models/toko.dart';

import 'base_model.dart';

class Makanan implements ISendable {
  int id;
  String nama;
  double harga;
  int stok;
  String imgUrl;
  Toko toko;

  Makanan({
    required this.id,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.imgUrl,
    required this.toko,
  });

  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
    id: json['id'],
    nama: json['nama'],
    harga: json['harga'],
    stok: json['stok'] ?? 0,
    imgUrl: json['img_url'],
    toko: Toko.fromJson(json['toko']),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'harga': harga,
    'stok': stok,
    'img_url': imgUrl,
    'toko': toko.id, // Assuming you're only sending the toko ID
  };
}
