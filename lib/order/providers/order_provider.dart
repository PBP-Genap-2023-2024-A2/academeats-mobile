import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/order.dart';
import '../models/order_group.dart';

class OrderProvider with ChangeNotifier {
  final List<Order> _orders = [];
  List<OrderGroup> _orderGroups = [];

  List<Order> get orders => _orders;
  List<OrderGroup> get orderGroups => _orderGroups;

  Future<void> fetchOrders(String tokoId) async {
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/order/show_main_pembeli_json'));
    if (response.statusCode == 200) {
      // Print the response body (JSON data)
      print(response.body);
    } else {
      // If the request was not successful, print the error message
      print('Failed to fetch orders: ${response.statusCode}');
    }

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body)['order_groups'];
      _orderGroups = jsonResponse
          .map((orderGroup) => OrderGroup.fromJson(orderGroup))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> updateOrderStatus(int pk, String newStatus) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/order/edit_status_penjual'),
      body: {
        'order_id': pk.toString(),
        'order_status': newStatus,
      },
    );

    if (response.statusCode == 200) {
      final order = _orders.firstWhere((order) => order.pk == pk);
      order.status = newStatus;
      notifyListeners();
    } else {
      throw Exception('Failed to update order status');
    }
  }

  Future<void> cancelOrder(int orderGroupId) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/order/edit_status_batal/$orderGroupId'),
    );

    if (response.statusCode == 200) {
      final orderGroup = _orderGroups.firstWhere((og) => og.pk == orderGroupId);
      for (var order in orderGroup.orders) {
        order.status = 'DIBATALKAN';
      }
      notifyListeners();
    } else {
      throw Exception('Failed to cancel order');
    }
  }
}
