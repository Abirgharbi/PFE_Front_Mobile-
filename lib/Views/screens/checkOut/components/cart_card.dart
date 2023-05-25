import 'package:ARkea/utils/colors.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../Model/cart_model.dart';

import '../../../../ViewModel/order_controller.dart';
import '../../../widgets/rounded_icon_btn.dart';

var orderController = Get.put(OrderController());

class CartCard extends StatefulWidget {
  final Cart cart;
  OrderController orderController = Get.put(OrderController());

  CartCard({
    Key? key,
    required this.cart,
  }) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {
  @override
  Widget build(BuildContext context) {
    //int? quantity = widget.cart.quantity;
    return ColoredBox(
      color: Colors.white,
      child: Padding(
        padding:
            const EdgeInsets.only(right: 10, left: 10, top: 20, bottom: 20),
        child: Row(
          children: [
            SizedBox(
              width: 88,
              child: AspectRatio(
                aspectRatio: 0.88,
                child: Container(
                  padding: EdgeInsets.all(gWidth / 50),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F6F9),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Image.network(widget.cart.product.thumbnail),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cart.product.name,
                  style: const TextStyle(color: Colors.black, fontSize: 16),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Text.rich(
                  TextSpan(
                    text: "\$${widget.cart.product.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, color: MyColors.btnColor),
                    children: [
                      TextSpan(
                          text: " x${widget.cart.quantity}",
                          style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(width: 120),
            widget.cart.quantity == 1
                ? Column(
                    children: [
                      SizedBox(width: getProportionateScreenWidth(9)),
                      Text(
                        '${widget.cart.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: getProportionateScreenWidth(9)),
                      RoundedIconBtn(
                        icon: Icons.add,
                        showShadow: true,
                        press: () {
                          orderController.addToCart(widget.cart.product);
                          setState(() {
                            widget.cart.quantity = widget.cart.quantity;
                          });
                        },
                      ),
                    ],
                  )
                : Column(
                    children: [
                      RoundedIconBtn(
                        icon: Icons.remove,
                        press: () {
                          orderController.decreaseQuantity(widget.cart.product);
                          setState(() {
                            widget.cart.quantity = widget.cart.quantity;
                          });
                        },
                      ),
                      SizedBox(width: getProportionateScreenWidth(8)),
                      Text(
                        '${widget.cart.quantity}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      SizedBox(width: getProportionateScreenWidth(8)),
                      RoundedIconBtn(
                        icon: Icons.add,
                        showShadow: true,
                        press: () {
                          orderController.addToCart(widget.cart.product);
                          setState(() {
                            widget.cart.quantity = widget.cart.quantity;
                          });
                        },
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
