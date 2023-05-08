import 'dart:convert';

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
  RxBool isLogged = false.obs;

  void login() async {
    isNameEnabled.value = true;
    CustomerModel customerModel =
        CustomerModel(email: emailEditingController.text);
    var response = await NetworkHandler.post(
        customerModelToJson(customerModel), "user/login");
    isLogged.value = true;
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
      var data = json.decode(response);
      if (data['token'].toString().isNotEmpty) {
        QuickAlert.show(
          context: context!,
          type: QuickAlertType.success,
          text: "verify your magic link in your inbox",
        );
      }

      NetworkHandler.storeToken(data['token']);
      NetworkHandler.storeCustomer('customerName', data['customer']['name']);
      NetworkHandler.storeCustomer('customerEmail', data['customer']['email']);
      NetworkHandler.storeCustomer('customerId', data['customer']['_id']);
      NetworkHandler.storeCustomer('customerImage', data['customer']['image']);

      var dateTime = DateTime.parse(data['customer']['createdAt']);
      var JoinedDate = DateFormat.yMMMd("en-US").format(dateTime);

      NetworkHandler.storeCustomer('customerJoinedDate', JoinedDate);

      // Get.to(() => LandingPage());
    }
  }

  void logOut() async {
    isLogged.value = false;
    signupController.isSigned.value = false;
    NetworkHandler.storage.deleteAll();
    await FacebookAuth.instance.logOut();
    await signupController.googleSignIn.signOut();
    await _googleSignIn.signOut();
    accessToken = null;
    userDataf = null;

    Get.offAll(const LandingPage());
  }

  Map<String, dynamic>? userDataf = Map<String, dynamic>().obs;

  AccessToken? accessToken;
  RxBool checking = true.obs;

  @override
  void onInit() async {
    super.onInit();
    await NetworkHandler.storage.deleteAll();
    checkIfisLoggedIn();
  }

  Future checkIfisLoggedIn() async {
    var accessToken = await FacebookAuth.instance.accessToken;

    checking.value = false;

    if (accessToken != null) {
      isNameEnabled.value = false;
      final userData = await FacebookAuth.instance.getUserData();
      accessToken = accessToken;
      userDataf = userData;
    } else {
      loginfacebook();
    }
  }

  Future loginfacebook() async {
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ['public_profile', 'email']);
    isLogged.value = true;
    isNameEnabled.value = false;
    if (result.status == LoginStatus.success) {
      accessToken = result.accessToken;
      final userData = await FacebookAuth.instance.getUserData();
      userDataf = userData;
      print(userDataf);

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

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  Future<GoogleSignInAccount?> loginWithGoogle() async {
    try {
      var user = await _googleSignIn.signIn();
      isLogged.value = true;
      isNameEnabled.value = false;

      userDataf!.addAll({
        "email": user!.email,
        "name": user.displayName.toString(),
        "photoUrl": user.photoUrl.toString(),
      });
      NetworkHandler.storeCustomer('customerName', user.displayName.toString());
      NetworkHandler.storeCustomer('customerEmail', user.email);
      NetworkHandler.storeCustomer('customerImage', user.photoUrl.toString());
      Get.to(() => const LandingPage());
    } catch (error) {
      print(error);
    }
    return null;
  }
}
