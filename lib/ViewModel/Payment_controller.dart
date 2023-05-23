import 'dart:convert';

import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:ARkea/utils/shared_preferences.dart';

import '../Model/service/network_handler.dart';

class PaymentController extends GetxController {
  var email = '';
  var phone = '';
  var city = '';
  var country = '';
  var state = '';
  var zipCode = '';
  var line1 = '';
  var line2 = '';

  @override
  void onInit() async {
    super.onInit();
    email = await sharedPrefs.getPref('customerEmail');
    phone = await sharedPrefs.getPref('customerPhoneNumber');
    city = await sharedPrefs.getPref('city');
    country = await sharedPrefs.getPref('country');
    state = await sharedPrefs.getPref('state');
    zipCode = await sharedPrefs.getPref('zipCode');
    line1 = await sharedPrefs.getPref('line1');
    line2 = await sharedPrefs.getPref('line2');
  }

  OrderController orderController = Get.put(OrderController());
  Future<void> handlePayPress() async {
    orderController.addOrder();

    try {
      var billingDetails = BillingDetails(
        email: email,
        phone: phone,
        address: Address(
          city: city,
          country: country,
          line1: line1,
          line2: line2,
          state: state,
          postalCode: zipCode,
        ),
      ); // mocked data for tests

      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: PaymentMethodParams.card(
        paymentMethodData: PaymentMethodData(
          billingDetails: billingDetails,
        ),
      ));

      final paymentIntentResult = await PayEndpointMethodId(
        useStripeSdk: true,
        paymentMethodId: paymentMethod.id,
        currency: 'usd', // mocked data
        items: ['id-1'],
      );

      if (paymentIntentResult['error'] != null) {
        Get.snackbar("Error", '${paymentIntentResult['error']}');

        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == null) {
        Get.snackbar("Success", "Payment succeeded");
        Get.toNamed('/landing');

        return;
      }

      if (paymentIntentResult['clientSecret'] != null &&
          paymentIntentResult['requiresAction'] == true) {
        final paymentIntent = await Stripe.instance
            .handleNextAction(paymentIntentResult['clientSecret']);
      }
    } catch (e) {
      Get.snackbar("Error", '${e}');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> PayEndpointMethodId({
    required bool useStripeSdk,
    required String paymentMethodId,
    required String currency,
    List<String>? items,
  }) async {
    var body = json.encode({
      'useStripeSdk': useStripeSdk,
      'paymentMethodId': paymentMethodId,
      'currency': currency,
      'amount': orderController.orderSum.value * 100,
    });

    var response = await NetworkHandler.post(body, "order/pay");
    return json.decode(response);
  }
}
