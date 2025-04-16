import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARkea/Model/customer_model.dart';
import 'package:ARkea/Model/service/network_handler.dart';
import 'package:ARkea/utils/shared_preferences.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Map<String, dynamic>? userDataf = <String, dynamic>{};
  AccessToken? accessToken;

  Future<Map<String, dynamic>> loginWithEmail(String email) async {
    CustomerModel customerModel = CustomerModel(email: email);
    var response = await NetworkHandler.post(
        customerModelToJson(customerModel), "user/login");
    var data = json.decode(response);

    if (data['token'] != null) {
      sharedPrefs.setPref('token', data['token'].toString());
    }

    var customerAdress = await NetworkHandler.get(
        "user/customer/address/${data['customer']['email']}");
    var adressData = json.decode(customerAdress);

    sharedPrefs.setPref('customerName', data['customer']['name']);
    sharedPrefs.setPref('customerEmail', data['customer']['email']);
    sharedPrefs.setPref('customerId', data['customer']['_id']);
    sharedPrefs.setPref('customerImage', data['customer']['image']);
    sharedPrefs.setPref('customerPhoneNumber', data['customer']['phone'] ?? '');

    sharedPrefs.setPref(
        'city', adressData['address'][0]['city']);
    sharedPrefs.setPref('country', adressData['address'][0]['country']);
    sharedPrefs.setPref('line1', adressData['address'][0]['line1']);
    sharedPrefs.setPref('line2', adressData['address'][0]['line2']);
    sharedPrefs.setPref('state', adressData['address'][0]['state']);
    sharedPrefs.setPref('zipCode',
        adressData['address'][0]['zipCode'].toString());

    return {
      'message': data['message'],
      'token': data['token'],
      'customer': data['customer'],
      'address': adressData['address'][0]
    };
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FacebookAuth.instance.logOut();
    await googleSignIn.signOut();
    accessToken = null;
    userDataf = null;
  }

  Future<Map<String, dynamic>?> loginWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      userDataf = await FacebookAuth.instance.getUserData();

      sharedPrefs.setPref('customerName', userDataf!['name']);
      sharedPrefs.setPref('customerEmail', userDataf!['email']);
      sharedPrefs.setPref(
          'customerImage', userDataf!['picture']['data']['url']);

      var response = await NetworkHandler.post(
          '{"email": "${userDataf!["email"]}"}', "user/oauth/login");
      var data = json.decode(response);
      sharedPrefs.setPref('token', data['token']);

      return userDataf;
    }
    return null;
  }

  Future<Map<String, dynamic>?> loginWithGoogle() async {
    try {
      var user = await googleSignIn.signIn();
      if (user == null) return null;

      userDataf!.addAll({
        "email": user.email,
        "name": user.displayName.toString(),
        "photoUrl": user.photoUrl.toString(),
      });

      sharedPrefs.setPref('customerName', user.displayName.toString());
      sharedPrefs.setPref('customerEmail', user.email);
      sharedPrefs.setPref('customerImage', user.photoUrl.toString());

      var response = await NetworkHandler.post(
          '{"email": "${user.email}"}', "user/oauth/login");
      var data = json.decode(response);
      sharedPrefs.setPref('token', data['token']);

      return userDataf;
    } catch (e) {
      print("Google login error: $e");
      return null;
    }
  }
}
