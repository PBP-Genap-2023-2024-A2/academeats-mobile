import 'dart:collection';

import 'package:academeats_mobile/models/makanan.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:academeats_mobile/utils/fetch.dart';
import 'package:flutter/material.dart';

import 'package:academeats_mobile/models/base_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartObject> _items = [];
  double totalHarga = 0;

  UnmodifiableListView<CartObject> get items => UnmodifiableListView(_items);

  void add(CartObject item) {
    _items.add(item);
    totalHarga += item.makanan.harga * item.jumlah;
    notifyListeners();
  }

  void remove(CartObject item) {
    _items.remove(item);
    totalHarga -= item.makanan.harga * item.jumlah;
    notifyListeners();
  }

  void fetchCart(User user) async {
    var keranjangData = await fetchData('keranjang/api/v1/get-keranjang-item/${user.username}/');

    for (CartObject item in keranjangData['data']) {
      add(item);
    }
  }

  void ngasal() {
    notifyListeners();
  }
}

class CartObject implements ISendable {
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

  @override
  Map<String, dynamic> toJson() => {
    'pk': pk,
    'makanan': makanan.toJson(),
    'jumlah': jumlah
  };
}
