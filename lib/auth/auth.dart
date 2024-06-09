import 'dart:convert';

import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:academeats_mobile/models/user.dart';

class AuthProvider extends CookieRequest {
  User? user;

  @override
  Future<dynamic> login(String url, dynamic data) async {
    final responseJson = await super.login(url, data);

    if (loggedIn) {
      user = User.fromJson(getJsonData());
    }

    return responseJson;
  }
}