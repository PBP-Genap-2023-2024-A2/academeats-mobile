import 'dart:convert';

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

Future<Map<String, dynamic>> fetchData(String path,
    {
      RequestMethod method = RequestMethod.get,
      Map<String, dynamic>? body,
    }) async {

  var uri = Uri(
    scheme: 'http',
    host: Constant.BACKEND_URI_LOCAL,
    path: path,
  );

  // Setting the request object
  var request = http.Request(method.value, uri);
  request.headers.addAll({
    "Access-Control-Allow_Origin": "*",
    "Content-Type": "application/json",
  });

  // Send the request to the server
  var response = await http.Client().send(request);

  String responseBody = '';

  // Transform the response body to string using utf8 format
  await response.stream.transform(utf8.decoder).forEach((element) {
    responseBody += element;
  });

  return jsonDecode(responseBody);
}
