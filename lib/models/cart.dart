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

  void add(String username, int id_makanan, int? jumlah) async {
    int _jumlah = jumlah ?? 1;
    
    final data = await fetchData('keranjang/api/v1/tambah-item/', method: RequestMethod.post, body: {
      'id_makanan': id_makanan,
      'username': username,
      'jumlah': _jumlah,
    });

    CartObject item = CartObject.fromJson(data);
    
    _add(item);
  }

  void remove(CartObject item) {
    _items.remove(item);
    totalHarga -= item.makanan.harga * item.jumlah;
    notifyListeners();
  }

  void _add(CartObject item) {
    _items.add(item);
    totalHarga += item.makanan.harga * item.jumlah;
    notifyListeners();
  }

  void fetchCart(User user) async {
    var keranjangData = await fetchData('keranjang/api/v1/get-keranjang-item/${user.username}/');

    for (var data in keranjangData['data']) {
      CartObject item = CartObject.fromJson(data);
      _add(item);
    }
  }

  void ngasal() {
    notifyListeners();
  }
}

class CartObject implements ISendable {
  int id;
  Makanan makanan;
  int jumlah;

  CartObject({
    required this.id,
    required this.makanan,
    required this.jumlah,
  });

  factory CartObject.fromJson(Map<String, dynamic> json) => CartObject(
    id: json["id"],
    makanan: Makanan.fromJson(json['makanan']),
    jumlah: json['jumlah'],
  );

  @override
  Map<String, dynamic> toJson() => {
    'id': id,
    'makanan': makanan.toJson(),
    'jumlah': jumlah
  };
}
