import 'dart:collection';

import 'package:academeats_mobile/models/makanan.dart';
import 'package:flutter/material.dart';

class Cart extends ChangeNotifier {
  final List<CartObject> _items = [];

  UnmodifiableListView<CartObject> get items => UnmodifiableListView(_items);

  void add(CartObject item) {
    _items.add(item);
    notifyListeners();
  }

  void remove(CartObject item) {
    _items.remove(item);
    notifyListeners();
  }
}

class CartObject {
  int pk;
  Makanan makanan;
  int jumlah;

  CartObject({
    required this.pk,
    required this.makanan,
    required this.jumlah,
  });

  factory CartObject.fromJson(Map<String, dynamic> json) => CartObject(
    pk: json["pk"],
    makanan: Makanan.fromJson(json['makanan']),
    jumlah: json['jumlah'],
  );

  Map<String, dynamic> toJson() => {
    'pk': pk,
    'makanan': makanan.toJson(),
    'jumlah': jumlah
  };
}
