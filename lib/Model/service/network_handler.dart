import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class NetworkHandler {
  static final client = http.Client();

  static Future<String> post(var body, String endpoint) async {
    var response = await client
        .post(buildUrl(endpoint), body: body, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
        })
        .then((http.Response response) => response.body)
        .catchError((Object error) => print(error));

    return response.toString();
  }

  static Future<String> delete(var body, String endpoint) async {
    var response = await client
        .delete(buildUrl(endpoint), body: body, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
        })
        .then((http.Response response) => response.body)
        .catchError((Object error) => print(error));

    return response.toString();
  }

  static Future<String> get(String endpoint) async {
    var response = await client
        .get(buildUrl(endpoint), headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
        })
        .then((http.Response response) => response.body)
        .catchError((Object error) => print(error));

    return response.toString();
  }

  static Future<String> put(var body, String endpoint) async {
    var response = await client
        .put(buildUrl(endpoint), body: body, headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': "*/*",
          'connection': 'keep-alive',
          'Accept-Encoding': 'gzip, deflate, br',
          HttpHeaders.authorizationHeader: 'Basic your_api_token_here',
        })
        .then((http.Response response) => response.body)
        .catchError((Object error) => print(error));

    return response.toString();
  }

  static Uri buildUrl(String endpoint) {
    // String host = "http://34.221.165.107/";
    String host = "http://10.0.2.2:8080/";

    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  }
}
