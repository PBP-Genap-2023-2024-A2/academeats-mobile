import 'package:academeats_mobile/models/order.dart';
import 'package:academeats_mobile/models/user.dart';

class OrderGroup {
  final int id;
  final String dateAdded;
  final double totalHarga;
  final User user;
  final List<Order> orders;
  final String status;

  OrderGroup({
    required this.id,
    required this.dateAdded,
    required this.totalHarga,
    required this.user,
    required this.orders,
    required this.status,
  });

  factory OrderGroup.fromJson(Map<String, dynamic> json) {
    var ordersList = json['orders'] as List? ?? [];
    List<Order> orders = ordersList.map((i) => Order.fromJson(i)).toList();

    return OrderGroup(
      id: json['id'] ?? 0,
      dateAdded: json['date_added'] ?? '',
      totalHarga: (json['total_harga'] ?? 0.0).toDouble(),
      user: User.fromJson(json['user'] ?? {}),
      orders: orders,
      status: json['status'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "date_added": dateAdded,
    "total_harga": totalHarga,
    "user": user.toJson(),
    "orders": orders.map((order) => order.toJson()).toList(),
    "status": status,
  };
}
