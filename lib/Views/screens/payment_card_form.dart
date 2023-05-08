import 'dart:convert';

import 'package:ARkea/Views/screens/checkOut/checkout.dart';
import 'package:ARkea/Views/screens/profil_page/noLoggedIn_profilPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import '../../ViewModel/Payment_controller.dart';
import '../../ViewModel/login_controller.dart';
import '../../ViewModel/signup_controller.dart';
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
  @override
  void initState() {
    controller.addListener(update);
    super.initState();
  }

  void update() => setState(() {});
  @override
  void dispose() {
    controller.removeListener(update);
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Checkout'),
      body: Obx(
        () => loginController.isLogged.value == false &&
                signupController.isSigned.value == false
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
      ),
    );
  }
}
