import 'dart:convert';

import 'package:academeats_mobile/models/base_model.dart';
import 'package:academeats_mobile/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:academeats_mobile/assets/constants.dart' as Constant;

enum RequestMethod {
  get,
  post,
  patch,
  put,
  delete
}

extension RequestMethodExtension on RequestMethod {
  String get value {
    switch (this) {
      case RequestMethod.get:
        return "GET";
      case RequestMethod.post:
        return "POST";
      case RequestMethod.patch:
        return "PATCH";
      case RequestMethod.put:
        return "PUT";
      case RequestMethod.delete:
        return "DELETE";
    }
  }
}

enum RequestDataType {
  json,
  form,
}

extension RequestDataTypeExtension on RequestDataType {
  String get value {
    switch (this) {
      case RequestDataType.json:
        return "application/json";
      case RequestDataType.form:
        return "application/x-www-form-urlencoded";
    }
  }
}

Future<Map<String, dynamic>> fetchData(String path,
    {
      RequestMethod method = RequestMethod.get,
      RequestDataType dataType = RequestDataType.json,
      Map<String, String>? headers,
      Map<String, dynamic>? body,
      User? user,
    }) async {

  Uri uri = Uri.parse(Constant.BACKEND_URI_LOCAL + path);
  String bodyStr;

  // set the default value to application/json
  var requestHeader = headers ?? {};

  requestHeader.addAll({
    "Content-Type": dataType.value
  });

  var request = http.Request(method.value, uri);
  request.headers.addAll(requestHeader);

  // Parse body to string
  if (body != null) {
    if (user != null) {
      body.addAll(user.toJson());
    }
    bodyStr = jsonEncode(body);
  } else {
    bodyStr = jsonEncode(user?.toJson());
  }

  request.body = bodyStr;

  var response = await http.Client().send(request);

  String responseBody = '';

  await response.stream.transform(utf8.decoder).forEach((element) {
    responseBody += element;
  });

  var data = jsonDecode(responseBody);

  Map<String, dynamic> returned;

  if (data is List) {
    returned = {'data': data};
  } else {
    returned = data;
  }

  return returned;
}
