import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARkea/utils/shared_preferences.dart';

import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/quickalert.dart';

import '../Model/customer_model.dart';
import '../Model/service/network_handler.dart';

class SignupScreenController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController nameEditingController = TextEditingController();
  BuildContext? context = Get.key.currentContext;

  RxBool privacy = false.obs;
  RxBool isEnabled = false.obs;
  var isEnabledName = true.obs;
  RxBool checkboxValue = false.obs;
  RxBool validName = false.obs;
  RxBool validEmail = false.obs;

  void signUp() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    isEnabledName.value = true;
    privacy.value = true;
    CustomerModel customerModel = CustomerModel(
        email: emailEditingController.text, name: nameEditingController.text);
    var response = await NetworkHandler.post(
        customerModelToJson(customerModel), "user/register");
    print(response);
    var data = await json.decode(response);
    if (data["message"] == "Email already exists") {
      QuickAlert.show(
        context: context!,
        type: QuickAlertType.warning,
        text: data["message"],
      );
    } else {
      QuickAlert.show(
        context: context!,
        type: QuickAlertType.success,
        text: "Your account has been created. please check your email",
      );

      var customerAdress = await NetworkHandler.get(
          "user/customer/address/${data['customer']['email']}");

      var adressData = json.decode(customerAdress);
      String address =
          "${adressData['address'][0]['line1']}, ${adressData['address'][0]['city']}, ${adressData['address'][0]['country']}";

      sharedPrefs.setPref('token', data['token']);
      sharedPrefs.setPref('customerName', data['customer']['name']);
      sharedPrefs.setPref('customerEmail', data['customer']['email']);
      sharedPrefs.setPref('customerId', data['customer']['_id']);
      sharedPrefs.setPref('customerImage', data['customer']['image']);
      sharedPrefs.setPref('city', adressData['address'][0]['city']);
      sharedPrefs.setPref('country', adressData['address'][0]['country']);
      sharedPrefs.setPref('line1', adressData['address'][0]['line1']);
      sharedPrefs.setPref('line2', adressData['address'][0]['line2']);
      sharedPrefs.setPref('state', adressData['address'][0]['state']);
      sharedPrefs.setPref(
          'zipCode', adressData['address'][0]['zipCode'].toString());
      sharedPrefs.setPref('address', address);

      Get.to(() => const LandingPage());
    }
  }

  Map<String, dynamic>? userDataf = <String, dynamic>{}.obs;

  AccessToken? accessToken;
  RxBool checking = true.obs;

  @override
  void onInit() async {
    super.onInit();
  }

  signUpWithFacebook() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    isEnabledName.value = false;
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      print(userData);
      userDataf = userData;

      sharedPrefs.setPref('customerName', userDataf!['name']);
      await sharedPrefs.getPref('customerEmail');
      sharedPrefs.setPref('customerEmail', userDataf!['email']);
      sharedPrefs.setPref(
          'customerImage', userDataf!['picture']['data']['url']);
    }

    var jsonObject = {
      "email": userDataf!['email'],
      "name": userDataf!['name'],
      "image": userDataf!['picture']['data']['url'],
    };

    print(jsonObject);
    var response = await NetworkHandler.post(
        json.encode(jsonObject), "user/oauth/register");
    var data = await json.decode(response);
    print(data);

    if (data["message"] == "Email already exists") {
      QuickAlert.show(
        context: context!,
        type: QuickAlertType.warning,
        text:
            "you already have an account with this email that you are using with your facebook account",
      );
    } else {
      sharedPrefs.setPref('token', data['token']);
      Get.to(() => const LandingPage());
    }

    checking.value = false;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  signUpWithGoogle() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      var user = await googleSignIn.signIn();
      isEnabledName.value = false;

      userDataf!.addAll({
        "email": user!.email,
        "name": user.displayName.toString(),
        "photoUrl": user.photoUrl.toString(),
      });
      CustomerModel customerModel = CustomerModel(
        email: user.email,
        name: user.displayName.toString(),
        image: user.photoUrl.toString(),
      );
      var response = await NetworkHandler.post(
          customerModelToJson(customerModel), "user/oauth/register");
      var data = await json.decode(response);

      sharedPrefs.setPref('token', data['token']);
      sharedPrefs.setPref('customerName', user.displayName.toString());
      sharedPrefs.setPref('customerEmail', user.email);
      sharedPrefs.setPref('customerImage', user.photoUrl.toString());

      Get.to(() => const LandingPage());
    } catch (error) {
      print(error);
    }
  }
}
