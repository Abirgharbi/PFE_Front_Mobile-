import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ViewModel/product_controller.dart';
import '../../../../utils/sizes.dart';
import 'cart_card.dart';

var orderController = Get.put(OrderController());

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gWidth / 20),
      child: ListView.builder(
        itemCount: orderController.demoCarts.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                orderController.demoCarts.removeAt(index);
                orderController.productNbInCart.value =
                    orderController.demoCarts.length;
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
            child: CartCard(cart: orderController.demoCarts[index]),
          ),
        ),
      ),
    );
  }
}
