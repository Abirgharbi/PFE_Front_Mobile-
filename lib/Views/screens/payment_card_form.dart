import 'dart:convert';

import 'package:ARkea/Views/screens/checkOut/checkout.dart';
import 'package:ARkea/Views/screens/profil_page/noLoggedIn_profilPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../ViewModel/Payment_controller.dart';
import '../../ViewModel/login_controller.dart';
import '../../ViewModel/signup_controller.dart';
import '../../utils/shared_preferences.dart';
import '../widgets/app_bar.dart';
import '../widgets/card_form.dart';
import '../widgets/loading_button.dart';
import 'package:get/get.dart';

final loginController = Get.put(LoginController());
final signupController = Get.put(SignupScreenController());

class PaymentCardForm extends StatefulWidget {
  const PaymentCardForm({super.key});

  @override
  PaymentCardFormState createState() => PaymentCardFormState();
}

class PaymentCardFormState extends State<PaymentCardForm> {
  final controller = CardFormEditController();
  PaymentController paymentController = Get.put(PaymentController());
  String token = '';

  @override
  void initState() {
    controller.addListener(update);
    super.initState();
    checkToken();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  checkToken() async {
    String updatedToken = await sharedPrefs.getPref('token');
    setState(() {
      token = updatedToken;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: token.isEmpty
          ? const noLoggedIn_profilPage()
          : SingleChildScrollView(
              child: Column(
                children: [
                  Checkout(),
                  CardForm(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      CardFormField(
                        controller: controller,
                        countryCode: 'CH',
                        style: CardFormStyle(
                          backgroundColor: Colors.white,
                          borderColor: Colors.blueGrey,
                          textColor: Colors.black,
                          fontSize: 24,
                          placeholderColor: Colors.black,
                        ),
                      ),
                      LoadingButton(
                        onPressed: controller.details.complete == true
                            ? paymentController.handlePayPress
                            : null,
                        text: 'Pay',
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
