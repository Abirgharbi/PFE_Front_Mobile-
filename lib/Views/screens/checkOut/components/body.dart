import 'dart:convert';

import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Model/product_model.dart';
import '../../../../utils/shared_preferences.dart';
import 'cart_card.dart';
import 'check_out_card.dart';

var orderController = Get.put(OrderController());

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List<Product> addedProducts = [];
  List<String> productsCart = [];
  @override
  void initState() {
    super.initState();
    getWhishlist();
  }

  getWhishlist() async {
    productsCart = await sharedPrefs.getStringList("cart");
    addedProducts =
        productsCart.map((e) => Product.fromJson(jsonDecode(e))).toList();
    setState(() {
      addedProducts = addedProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: gWidth / 20),
        child: ListView.builder(
          itemCount: addedProducts.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                setState(() {
                  addedProducts.removeAt(index);
                  orderController.productNbInCart.value = addedProducts.length;
                  orderController.orderSum.value =
                      orderController.orderSum.value -
                          (addedProducts[index].price *
                              addedProducts[index].quantity!.toDouble());
                });
              },
              background: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE6E6),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: const [
                    Spacer(),
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              child: CartCard(cart: addedProducts[index]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CheckoutCard(),
    );
  }
}
