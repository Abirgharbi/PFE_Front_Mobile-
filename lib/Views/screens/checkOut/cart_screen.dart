import 'dart:convert';

import 'package:arkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/cart_model.dart';
import '../../../Model/product_model.dart';
import '../../../ViewModel/order_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/shared_preferences.dart';
import '../../../utils/sizes.dart';
import 'components/body.dart';

var orderController = Get.put(OrderController());

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Cart> addedProducts = [];

  @override
  void initState() {
    super.initState();
    getCartlist();
  }

  getCartlist() async {
    List<String> productsCart = await sharedPrefs.getStringList("cart");
    addedProducts =
        productsCart.map((e) => Cart.fromJson(jsonDecode(e))).toList();
    setState(() {
      addedProducts = addedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Get.toNamed('/landing');
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
              "${addedProducts.length} items",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: addedProducts.isEmpty
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
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MyColors.btnColor,
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
                            Text("back to home"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ))
          : const Body(),
      // bottomNavigationBar: CheckoutCard(),
    );
  }
}
