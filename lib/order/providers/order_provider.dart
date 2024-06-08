import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/order.dart';
import '../../models/order_group.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<OrderGroup> _orderGroups = [];

  List<Order> get orders => _orders;
  List<OrderGroup> get orderGroups => _orderGroups;

  /*Future<void> fetchOrdersPenjual() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/order/api/v1/1/orders'));

    if (response.statusCode == 200) {
      List<dynamic> jsonResponse = json.decode(response.body);
      _orders = jsonResponse
          .map<Order>((json) => Order.fromJson(json as Map<String, dynamic>))
          .toList();
      notifyListeners();
    } else {
      throw Exception('Failed to load orders');
    }
  }*/

  Future<void> fetchOrdersPembeli(String tokoId) async {
    final response =
    await http.get(Uri.parse('http://127.0.0.1:8000/order/api/v1/order_group/'));
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

/*  Future<void> updateOrderStatus(int pk, String newStatus) async {
    try {
      // Fetch the data and handle the response
      final response = await fetchData(
        'order/update_status_penjual',
        method: RequestMethod.post,
        body: {
          'order_id': pk.toString(),
          'order_status': newStatus,
        },
      );

      // Check the response for success status
      if (response['status'] == 'success') {
        final order = _orders.firstWhere((order) => order.id == pk);
        order.status = newStatus;
        notifyListeners();
      } else {
        // Handle specific error messages if available
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      // Handle errors such as network issues
      throw Exception('Failed to update order status: $e');
    }
  }*/

  Future<void> cancelOrder(OrderGroup og) async {
    try {
      final response = await fetchData('order/update_status_batal',
      method: RequestMethod.post,
        body: {
        'og_id': og.id
        }
      );

      if (response['status'] == 'success') {
        final orderGroup = _orderGroups.firstWhere((orderGroups) => orderGroups.id == og.id);
        for (Order order in orders) {
          order.status = "DIBATALKAN";
          notifyListeners();
        }
      }
      else {
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    }
    catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }



}
