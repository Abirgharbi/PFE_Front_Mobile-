import 'dart:convert';

import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

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
    email = await NetworkHandler.getItem('customerEmail');
    phone = await NetworkHandler.getItem('customerPhoneNumber');
    city = await NetworkHandler.getItem('city');
    country = await NetworkHandler.getItem('country');
    state = await NetworkHandler.getItem('state');
    zipCode = await NetworkHandler.getItem('zipCode');
    line1 = await NetworkHandler.getItem('line1');
    line2 = await NetworkHandler.getItem('line2');
  }

  OrderController orderController = Get.put(OrderController());
  Future<void> handlePayPress() async {
    // update product quantity
    
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
      'items': items,
      'amount': orderController.orderSum.value * 100,
    });

    var response = await NetworkHandler.post(body, "order/pay");
    return json.decode(response);
  }
}
