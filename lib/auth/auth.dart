import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:academeats_mobile/models/user.dart';

class AuthProvider extends CookieRequest with ChangeNotifier {
  User? user;

  @override
  Future<dynamic> login(String url, dynamic data) async {
    final responseJson = await super.login(url, data);

    if (loggedIn) {
      user = User.fromJson(getJsonData());
    }

    return responseJson;
  }

  void increaseSaldo(int amount) {
    if (user != null) {
      user!.saldo += amount;
      user!.saldo -= 1000;
      notifyListeners();
    }

  }
}