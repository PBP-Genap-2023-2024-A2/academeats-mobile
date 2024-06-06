import 'package:academeats_mobile/models/toko.dart';

class Makanan {
  int pk;
  String nama;
  double harga;
  int stok;
  String imgUrl;
  Toko? toko;

  Makanan({
    required this.pk,
    required this.nama,
    required this.harga,
    required this.stok,
    required this.imgUrl,
    this.toko,
  });

  factory Makanan.fromJson(Map<String, dynamic> json) => Makanan(
    pk: json['pk'],
    nama: json['nama'],
    harga: json['harga'],
    stok: json['stok'],
    imgUrl: json['img_url'],
    toko: Toko.fromJson(json['toko']),
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'nama': nama,
    'harga': harga,
    'stok': stok,
    'img_url': imgUrl,
    'toko': toko?.toJson(),
  };
}