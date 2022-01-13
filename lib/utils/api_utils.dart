import 'dart:convert';

import 'package:deart/models/api_response.dart';
import 'package:http/http.dart' as http;

T parseResponse<T>(http.Response response, Function fromJsonT) {
  Map<String, dynamic> decodedResponse =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

  return APIResponse<T>.fromJson(decodedResponse, fromJsonT).response;
}

T parseAuthResponse<T>(http.Response response, Function fromJsonT) {
  Map<String, dynamic> decodedResponse =
      jsonDecode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;

  return fromJsonT(decodedResponse);
}
