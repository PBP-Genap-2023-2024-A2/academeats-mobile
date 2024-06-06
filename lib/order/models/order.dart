class Order {
  final int pk;
  final String nama;
  final int quantity;
  String status;

  Order({
    required this.pk,
    required this.nama,
    required this.quantity,
    required this.status,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      pk: json['id'],
      nama: json['food_name'],
      quantity: json['quantity'],
      status: json['status'],
    );
  }
}
