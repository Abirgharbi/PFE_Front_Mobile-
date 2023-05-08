import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NetworkHandler {
  static final client = http.Client();
  static final storage = FlutterSecureStorage();

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
    // "https://arkea.up.railway.app/
    // String host = "https://arkea.up.railway.app/";
    String host = "https://arkea.up.railway.app/";

    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  }

  static void storeToken(var TokenValue) async {
    await storage.write(key: 'token', value: TokenValue);
  }

  static void storeCustomer(String itemKey, String itemValue) async {
    await storage.write(key: itemKey, value: itemValue);
  }

  static Future<String> getItem(String itemKey) {
    return storage.read(key: itemKey).then((value) {
      String res = value.toString();
      return res;
    });
  }

  static void getCustomerName() async {
    await NetworkHandler.getItem('customerEmail');
  }

  static void deleteItem(String itemKey) async {
    await storage.delete(key: itemKey);
  }
}
