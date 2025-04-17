import 'package:arkea/Views/screens/ProductDetails/componentsDetailScreen/ArView.dart';
import 'package:arkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../Model/product_model.dart';
import '../../../../utils/colors.dart';

import '../../../widgets/rounded_icon_btn.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';
import '../../../../ViewModel/order_controller.dart';

class Body extends StatelessWidget {
  final Product product;

  Body({Key? key, required this.product}) : super(key: key);

  var orderController = Get.put(OrderController());
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          product.model != null
              ? ArScreen(product: product)
              : ProductImages(product: product),
          TopRoundedContainer(
            color: Colors.white,
            child: Column(
              children: [
                ProductDescription(
                  product: product,
                  pressOnSeeMore: () {},
                ),
                TopRoundedContainer(
                  color: const Color(0xFFF6F7F9),
                  child: Column(
                    children: [
                      product.colors != null
                          ? ColorImage(
                              product: product,
                            )
                          : Container(),
                      TopRoundedContainer(
                        color: Colors.white,
                        child: Padding(
                            padding: EdgeInsets.only(
                              left: gWidth * 0.15,
                              right: gWidth * 0.15,
                              bottom: (40 / 375.0) * gWidth,
                              top: (15 / 375.0) * gWidth,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RoundedIconBtn(
                                  icon: Icons.add_shopping_cart_outlined,
                                  press: () {
                                    Get.toNamed('/cart');
                                  },
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: gWidth / 30,
                                      horizontal: gHeight / 30),
                                  decoration: BoxDecoration(
                                      color: MyColors.btnBorderColor,
                                      border: Border.all(
                                        color: MyColors.btnBorderColor,
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(15.0),
                                    onTap: () {
                                      orderController.addToCart(product);
                                      Get.snackbar(
                                          "Success", "product added to cart",
                                          // colorText: Colors.black,
                                          // backgroundColor: Colors.white
                                          );
                                    },
                                    splashColor: MyColors.btnBorderColor,
                                    child: const Center(
                                      child: Text(
                                        "Add to Cart",
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
