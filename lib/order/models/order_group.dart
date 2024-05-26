import 'order.dart';

class OrderGroup {
  final int pk;
  final int totalHarga;
  final String status;
  final List<Order> orders;

  OrderGroup({
    required this.pk,
    required this.totalHarga,
    required this.status,
    required this.orders,
  });

  factory OrderGroup.fromJson(Map<String, dynamic> json) {
    return OrderGroup(
      pk: json['pk'],
      totalHarga: json['total_harga'],
      status: json['status'],
      orders: (json['orders'] as List)
          .map((order) => Order.fromJson(order))
          .toList(),
    );
  }
}
