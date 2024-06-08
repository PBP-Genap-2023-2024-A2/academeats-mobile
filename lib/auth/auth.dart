import 'package:pbp_django_auth/pbp_django_auth.dart';

import 'package:academeats_mobile/models/user.dart';

class AuthProvider extends CookieRequest {
  User? user;

  @override
  Future<dynamic> login(String url, dynamic data) async {
    var body = await super.login(url, data);

    user = User.fromJson(body);

    return body;
  }
}