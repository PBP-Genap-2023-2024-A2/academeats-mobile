import 'package:academeats_mobile/models/user.dart';
import 'makanan.dart';

class KeranjangItem {
  final int id;
  int jumlah;
  final User user;
  final Makanan makanan;

  KeranjangItem({
    required this.id,
    required this.jumlah,
    required this.user,
    required this.makanan,
  });

  factory KeranjangItem.fromJson(Map<String, dynamic> json) {
    return KeranjangItem(
      id: json['id'],
      jumlah: json['jumlah'],
      user: User.fromJson(json['user']),
      makanan: Makanan.fromJson(json['makanan']),
    );
  }
}