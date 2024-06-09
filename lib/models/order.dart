import 'package:academeats_mobile/models/order_group.dart';
import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/toko.dart';
import 'package:academeats_mobile/models/user.dart';

class Order {
  final int id;
  final String nama;
  final int quantity;
  String status;
  final OrderGroup orderGroup;
  final Makanan makanan;
  final Toko toko;
  final User user;

  Order({
    required this.id,
    required this.nama,
    required this.quantity,
    required this.status,
    required this.orderGroup,
    required this.makanan,
    required this.toko,
    required this.user,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] ?? 0,
      nama: json['makanan']?['nama'] ?? '',
      quantity: json['quantity'] ?? 0,
      status: json['status'] ?? 'UNKNOWN',
      orderGroup: OrderGroup.fromJson(json['order_group'] ?? {}),
      makanan: Makanan.fromJson(json['makanan'] ?? {}),
      toko: Toko.fromJson(json['toko'] ?? {}),
      user: User.fromJson(json['user'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "quantity": quantity,
    "status": status,
    "order_group": orderGroup.toJson(),
    "makanan": makanan.toJson(),
    "toko": toko.toJson(),
    "user": user.toJson(),
  };
}