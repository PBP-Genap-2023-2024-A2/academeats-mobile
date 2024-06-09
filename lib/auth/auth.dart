import 'dart:convert';

import 'package:academeats_mobile/utils/fetch.dart';
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
      fetchData(
                'u/api/v1/top-up/', 
                method: RequestMethod.post, 
                body: {
                      'username': user?.username ?? '',
                      'jumlah': amount,
                    });
      user!.saldo += amount;
      user!.saldo -= 1000;
      notifyListeners();
    }
  }
  
}