import 'dart:convert';

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
  RxBool isSigned = false.obs;

  void signUp() async {
    isEnabledName.value = true;
    privacy.value = true;
    isSigned.value = true;
    CustomerModel customerModel = CustomerModel(
        email: emailEditingController.text, name: nameEditingController.text);
    var response = await NetworkHandler.post(
        customerModelToJson(customerModel), "user/register");

    var data = await json.decode(response);
    if (data["message"] == "Email already exists") {
      QuickAlert.show(
        context: context!,
        type: QuickAlertType.warning,
        text: data["message"],
      );
    } else {
      var data = json.decode(response);
      QuickAlert.show(
        context: context!,
        type: QuickAlertType.success,
        text: "Your account has been created. please check your email",
      );

      var customerAdress = await NetworkHandler.get(
          "user/customer/address/${data['customer']['email']}");
      var adressData = json.decode(customerAdress);
      print(adressData);
      NetworkHandler.storeToken(data['Token']);
      NetworkHandler.storeCustomer('customerName', data['customer']['name']);
      NetworkHandler.storeCustomer('customerEmail', data['customer']['email']);
      NetworkHandler.storeCustomer('customerId', data['customer']['_id']);
      NetworkHandler.storeCustomer('customerImage', data['customer']['image']);

      var dateTime = DateTime.parse(data['customer']['createdAt']);
      var joinedDate = DateFormat.yMMMd("en-US").format(dateTime);

      NetworkHandler.storeCustomer('customerJoinedDate', joinedDate);

      NetworkHandler.storeCustomer('city', adressData['address'][0]['city']);
      NetworkHandler.storeCustomer(
          'country', adressData['address'][0]['country']);
      NetworkHandler.storeCustomer('line1', adressData['address'][0]['line1']);
      NetworkHandler.storeCustomer('line2', adressData['address'][0]['line2']);
      NetworkHandler.storeCustomer('state', adressData['address'][0]['state']);
      NetworkHandler.storeCustomer(
          'zipCode', adressData['address'][0]['zipCode'].toString());

      String address =
          "${adressData['address'][0]['line1']}, ${adressData['address'][0]['city']}, ${adressData['address'][0]['country']}";
      NetworkHandler.storeCustomer('address', address);
      Get.to(() => const LandingPage());
    }
  }

  Map<String, dynamic>? userDataf = Map<String, dynamic>().obs;

  AccessToken? accessToken;
  RxBool checking = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await NetworkHandler.storage.deleteAll();
  }

  Future<void> signupFacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    // isSigned.value = true;
    isEnabledName.value = false;
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      userDataf = userData;

      NetworkHandler.storeCustomer('customerName', userDataf!['name']);
      NetworkHandler.storeCustomer('customerEmail', userDataf!['email']);
      NetworkHandler.storeCustomer(
          'customerImage', userDataf!['picture']['data']['url']);
      Get.to(() => const LandingPage());
    } else {
      // essai.value = "gharbi";
    }
    checking.value = false;
  }

  final GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      var user = await googleSignIn.signIn();
      // isSigned.value = true;
      isEnabledName.value = false;

      userDataf!.addAll({
        "email": user!.email,
        "name": user.displayName.toString(),
        "photoUrl": user.photoUrl.toString(),
      });
      NetworkHandler.storeCustomer('customerName', user.displayName.toString());
      NetworkHandler.storeCustomer('customerEmail', user.email);
      NetworkHandler.storeCustomer('customerImage', user.photoUrl.toString());
    } catch (error) {
      print(error);
    }
  }

  // _logout() async {
  //   await FacebookAuth.instance.logOut();
  //   accessToken = null;
  //   userData = null;
  // }
}
