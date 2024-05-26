// To parse this JSON data, do
//
//     final order = orderFromJson(jsonString);

import 'dart:convert';

Order orderFromJson(String str) => Order.fromJson(json.decode(str));

String orderToJson(Order data) => json.encode(data.toJson());

class Order {
    List<OrderGroup> orderGroups;

    Order({
        required this.orderGroups,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderGroups: List<OrderGroup>.from(json["order_groups"].map((x) => OrderGroup.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "order_groups": List<dynamic>.from(orderGroups.map((x) => x.toJson())),
    };
}

class OrderGroup {
    int pk;
    int totalHarga;
    String status;
    List<OrderElement> orders;

    OrderGroup({
        required this.pk,
        required this.totalHarga,
        required this.status,
        required this.orders,
    });

    factory OrderGroup.fromJson(Map<String, dynamic> json) => OrderGroup(
        pk: json["pk"],
        totalHarga: json["total_harga"],
        status: json["status"],
        orders: List<OrderElement>.from(json["orders"].map((x) => OrderElement.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "pk": pk,
        "total_harga": totalHarga,
        "status": status,
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
    };
}

class OrderElement {
    String foodName;
    int quantity;
    String status;
    int id;

    OrderElement({
        required this.foodName,
        required this.quantity,
        required this.status,
        required this.id,
    });

    factory OrderElement.fromJson(Map<String, dynamic> json) => OrderElement(
        foodName: json["food_name"],
        quantity: json["quantity"],
        status: json["status"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "food_name": foodName,
        "quantity": quantity,
        "status": status,
        "id": id,
    };
}
