import 'dart:convert';

import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Model/cart_model.dart';
import '../../../../Model/product_model.dart';
import '../../../../utils/shared_preferences.dart';
import 'cart_card.dart';
import 'check_out_card.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  OrderController orderController = Get.put(OrderController());

  @override
  void initState() {
    super.initState();
    getCartList();
  }

  Future<void> getCartList() async {
    List<String> productsCart = await sharedPrefs.getStringList("cart");
    setState(() {
      List<Cart> addedProducts =
          productsCart.map((e) => Cart.fromJson(jsonDecode(e))).toList();
      orderController.productCarts.value =
          productsCart.map((e) => Cart.fromJson(jsonDecode(e))).toList();
    });
  }

  void removeProductFromCart(int index) {
    setState(() {
      final removedProduct = orderController.productCarts[index];
      orderController.productCarts
          .removeWhere((cart) => cart.product.id == removedProduct.product.id);
      final removedProductCost =
          removedProduct.product.price * removedProduct.quantity;
      orderController.orderSum.value -= removedProductCost;
      sharedPrefs.setStringList(
        "cart",
        orderController.productCarts
            .map((e) => jsonEncode(e.toJson()))
            .toList(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: gWidth / 20),
        child: ListView.builder(
          itemCount: orderController.productCarts.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                removeProductFromCart(index);
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
              child: CartCard(cart: orderController.productCarts[index]),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CheckoutCard(),
    );
  }
}
