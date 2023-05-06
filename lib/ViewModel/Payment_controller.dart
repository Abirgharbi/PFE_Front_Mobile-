import 'dart:convert';

import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../Model/service/network_handler.dart';

class PaymentController extends GetxController {
  // final controller = CardFormEditController();

  // @override
  // void initState() {
  //   controller.addListener(update);
  // }

  // @override
  // void dispose() {
  //   controller.removeListener(update);
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> handlePayPress() async {
    // if (!controller.details.complete) {
    //   return;
    // }

    try {
      const billingDetails = BillingDetails(
        email: 'ilyesbenhajdahmane@gmail.com',
        phone: '+41 79 123 45 67',
        address: Address(
          city: 'Lausanne',
          country: 'CH',
          line1: 'Rue de la Paix 10',
          line2: '',
          state: 'lausanne',
          postalCode: '4000',
        ),
      ); // mocked data for tests

      final paymentMethod = await Stripe.instance.createPaymentMethod(
          params: const PaymentMethodParams.card(
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
      'items': items
    });

    var response = await NetworkHandler.post(body, "order/pay");
    return json.decode(response);

    //   final url = Uri.parse('https://arkea.up.railway.app/order/pay');
    //   final response = await http.post(
    //     url,
    //     headers: {
    //       'Content-Type': 'application/json',
    //     },
    //     body: json.encode({
    //       'useStripeSdk': useStripeSdk,
    //       'paymentMethodId': paymentMethodId,
    //       'currency': currency,
    //       'items': items
    //     }),
    //   );
    //   return json.decode(response.body);
    // }
  }
}
