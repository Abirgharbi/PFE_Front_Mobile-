import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ARkea/utils/shared_preferences.dart';
import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../Model/customer_model.dart';
import '../Model/service/network_handler.dart';
import 'signup_controller.dart';

final signupController = Get.put(SignupScreenController());

class LoginController extends GetxController {
  TextEditingController emailEditingController = TextEditingController();

  BuildContext? context = Get.key.currentContext;
  RxString customer = "user".obs;
  RxString customerEmail = "userMail".obs;
  RxString customerImage = "".obs;
  var isNameEnabled = true.obs;
  RxBool isLogginIn = false.obs;

  login() async {
    isLogginIn.value = true;
    isNameEnabled.value = true;
    CustomerModel customerModel =
        CustomerModel(email: emailEditingController.text);
    print(customerModelToJson(customerModel));

    try {
      var response = await NetworkHandler.post(
          customerModelToJson(customerModel), "user/login");
      var data = json.decode(response);

      sharedPrefs.setPref('token', data['token'].toString());
      if (data['token'].toString().isNotEmpty) {
        isLogginIn.value = false;
      }

      var message = json.decode(response)["message"];
      if (message == "Please create an account.") {
        QuickAlert.show(
          context: context!,
          type: QuickAlertType.warning,
          text: message,
        );
      }
      if (message == "Verify your Account.") {
        QuickAlert.show(
          context: context!,
          type: QuickAlertType.warning,
          text: message,
        );
      } else {
        if (data['token'].toString().isNotEmpty) {
          QuickAlert.show(
            context: context!,
            type: QuickAlertType.success,
            text: "verify your magic link in your inbox",
          );
        }
        isLogginIn.value = false;
      }

      var customerAdress = await NetworkHandler.get(
          "user/customer/address/${data['customer']['email']}");
      var adressData = json.decode(customerAdress);
      print(adressData);

      String address =
          "${adressData['address'][0]['line1']}, ${adressData['address'][0]['city']}, ${adressData['address'][0]['country']}";
      sharedPrefs.setPref('city', address);
      sharedPrefs.setPref('customerName', data['customer']['name']);
      var token = await sharedPrefs.getPref('customerName');

      sharedPrefs.setPref('customerName', data['customer']['name']);
      sharedPrefs.setPref('customerEmail', data['customer']['email']);
      sharedPrefs.setPref('customerId', data['customer']['_id']);
      sharedPrefs.setPref('customerImage', data['customer']['image']);

      sharedPrefs.setPref(
          'customerPhoneNumber', data['customer']['phone'] ?? '');

      sharedPrefs.setPref('city', adressData['address'][0]['city']);
      sharedPrefs.setPref('country', adressData['address'][0]['country']);
      sharedPrefs.setPref('line1', adressData['address'][0]['line1']);
      sharedPrefs.setPref('line2', adressData['address'][0]['line2']);
      sharedPrefs.setPref('state', adressData['address'][0]['state']);
      sharedPrefs.setPref(
          'zipCode', adressData['address'][0]['zipCode'].toString());
    } catch (e) {
      isLogginIn.value = false;
      print(e);
    }
  }

  void logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('customerId');
    await prefs.remove('customerName');
    await prefs.remove('customerEmail');
    await prefs.remove('customerImage');
    await prefs.remove('customerPhoneNumber');
    await prefs.remove('city');
    await prefs.remove('country');
    await prefs.remove('line1');
    await prefs.remove('line2');
    await prefs.remove('state');
    await prefs.remove('zipCode');
    // if i wanna clear all the shared preferences i can use this
    //  SharedPreferences preferences = await SharedPreferences.getInstance();
    //     await preferences.clear();

    await FacebookAuth.instance.logOut();
    await signupController.googleSignIn.signOut();
    await _googleSignIn.signOut();
    accessToken = null;
    userDataf = null;

    Get.offAll(const LandingPage());
  }

  Map<String, dynamic>? userDataf = <String, dynamic>{}.obs;

  AccessToken? accessToken;
  RxBool checking = true.obs;

  @override
  void onInit() async {
    super.onInit();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Future<void> loginfacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    isNameEnabled.value = false;
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      userDataf = userData;

      sharedPrefs.setPref('customerName', userDataf!['name']);
      sharedPrefs.setPref('customerEmail', userDataf!['email']);
      sharedPrefs.setPref(
          'customerImage', userDataf!['picture']['data']['url']);
      var response = await NetworkHandler.post(
          '{"email": "${userDataf!["email"]}"}', "user/oauth/login");
      var data = await json.decode(response);
      sharedPrefs.setPref('token', data['token']);

      Get.to(() => const LandingPage());
    }
    checking.value = false;
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<GoogleSignInAccount?> signUpWithGoogle() async {
    try {
      var user = await _googleSignIn.signIn();
      isNameEnabled.value = false;

      userDataf!.addAll({
        "email": user!.email,
        "name": user.displayName.toString(),
        "photoUrl": user.photoUrl.toString(),
      });
      sharedPrefs.setPref('customerName', user.displayName.toString());
      sharedPrefs.setPref('customerEmail', user.email);
      sharedPrefs.setPref('customerImage', user.photoUrl.toString());

      var response = await NetworkHandler.post(
          '{"email": "${user.email}"}', "user/oauth/login");
      var data = await json.decode(response);
      sharedPrefs.setPref('token', data['token']);

      Get.to(() => const LandingPage());
    } catch (error) {
      print(error);
    }
    return null;
  }
}
