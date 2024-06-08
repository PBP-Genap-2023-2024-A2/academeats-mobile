import 'package:academeats_mobile/models/toko.dart';

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
    stok: json['stok'],
    imgUrl: json['img_url'],
    toko: Toko.fromJson(json['toko']),
  );
  
  Map<String, dynamic> toJson() => {
    'id': id,
    'nama': nama,
    'harga': harga,
    'stok': stok,
    'img_url': imgUrl,
    'toko': toko.toJson(),
  };
}
