import 'package:arkea/Views/screens/checkOut/shipping-information.dart';
import 'package:arkea/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ViewModel/order_controller.dart';
import '../../../utils/shared_preferences.dart';

// Carrito de compras
class Checkout extends StatefulWidget {
  Checkout({Key? key}) : super(key: key);

  @override
  State<Checkout> createState() => _CheckoutState();
}

var orderController = Get.put(OrderController());

class _CheckoutState extends State<Checkout> {
  var orderSum = "0.00";
  @override
  void initState() {
    super.initState();
    getTotal();
  }

  getTotal() async {
    var total = await sharedPrefs.getPref('orderSum');
    setState(() {
      orderSum = total;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              const Text(
                'Shipping information',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  textStyle: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onPressed: () {
                  Get.toNamed("/address");
                },
                child: const Text(
                  'change',
                  style: TextStyle(
                    color: MyColors.btnBorderColor,
                  ),
                ),
              )
            ],
          ),
        ),
        const ShippingInfo(),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 17,
                ),
              ),
              Text(
                "\$ ${double.parse(orderSum).toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: MyColors.btnBorderColor,
                ),
              )
            ],
          ),
        ),
      ],
      // ),
    );
  }
}
