import 'package:ARkea/Views/screens/Home/home_page.dart';
import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../Model/cart_model.dart';
import '../../../ViewModel/order_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import 'components/body.dart';
import 'components/check_out_card.dart';

var orderController = Get.put(OrderController());

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0,
        title: Column(
          children: [
            const Text(
              "Your Cart",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${orderController.demoCarts.length} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Obx(
        () => orderController.productNbInCart == 0
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty-cart.png',
                    width: gWidth,
                    height: gHeight / 2,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your shopping basket is empty',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 60, right: 60, bottom: 30),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          primary: MyColors.btnColor,
                          side: const BorderSide(
                            color: MyColors.btnBorderColor,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          Get.to(const LandingPage());
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text("See Collection"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ))
            : const Body(),
      ),
      // bottomNavigationBar: CheckoutCard(),
    );
  }
}
