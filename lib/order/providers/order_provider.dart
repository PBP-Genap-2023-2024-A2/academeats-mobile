import 'package:flutter/material.dart';
import '../../models/order.dart';
import '../../models/order_group.dart';
import '../../utils/fetch.dart';

class OrderProvider with ChangeNotifier {
  List<Order> _orders = [];
  List<OrderGroup> _orderGroups = [];
  bool _isFetching = false;

  List<Order> get orders => _orders;
  List<OrderGroup> get orderGroups => _orderGroups;
  bool get isFetching => _isFetching;

  Future<void> fetchOrders(int tokoId) async {
    if (_isFetching) return;

    _isFetching = true;
    notifyListeners();

    try {
      final response = await fetchData('order/api/v1/$tokoId/orders');
      if (response != null && response['data'] != null) {
        _orders = (response['data'] as List).map((orderData) => Order.fromJson(orderData)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> fetchOrderGroups(int ogId) async {
    if (_isFetching) return;

    _isFetching = true;
    notifyListeners();

    try {
      final response = await fetchData('order/api/v1/order_group/$ogId');
      if (response != null && response['data'] != null) {
        _orders = (response['data'] as List).map((orderData) => Order.fromJson(orderData)).toList();
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to fetch orders: $e');
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> updateOrderStatus(String newStatus, Order order) async {
    try {
      final response = await fetchData(
        'order/edit_status_penjual/',
        method: RequestMethod.post,
        body: {
          'order_id': order.id,
          'order_status': newStatus,
        },
      );

      if (response['status'] == 'success') {
        order.status = newStatus;
        notifyListeners();
      } else {
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> cancelOrder(OrderGroup og) async {
    try {
      final response = await fetchData(
        'order/edit_status_batal/$og.id',
        method: RequestMethod.post,
        body: {
          'og_id': og.id,
        },
      );

      if (response['status'] == 'success') {
        List<Order> orders = og.orders;
        for (Order order in orders) {
          order.status = 'DIBATALKAN';
        }
        notifyListeners();
      } else {
        final errorMessage = response['message'] ?? 'Failed to update order status';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }
}
