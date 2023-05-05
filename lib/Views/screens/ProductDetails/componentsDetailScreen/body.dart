import 'package:ARkea/Views/screens/ProductDetails/componentsDetailScreen/ArView.dart';
import 'package:ARkea/Views/screens/checkOut/cart_screen.dart';
import 'package:ARkea/Views/screens/checkOut/checkout.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:get/get.dart';
import '../../../../Model/product_model.dart';
import '../../../../utils/colors.dart';

import '../../../widgets/rounded_icon_btn.dart';
import 'color_dots.dart';
import 'product_description.dart';
import 'top_rounded_container.dart';
import 'product_images.dart';

class Body extends StatelessWidget {
  final Product product;

  const Body({Key? key, required this.product}) : super(key: key);

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
                            child: Container(
                              width: size.width / 0.5,
                              height: size.height / 14,
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
                                  print(orderController.demoCarts);
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

class _addQuantityWidgetState extends State<addQuantityWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return quantity == 1
        ? Row(
            children: [
              SizedBox(width: getProportionateScreenWidth(8)),
              Text(
                '${quantity}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: getProportionateScreenWidth(8)),
              RoundedIconBtn(
                icon: Icons.add,
                showShadow: true,
                press: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          )
        : Row(
            children: [
              RoundedIconBtn(
                icon: Icons.remove,
                press: () {
                  setState(() {
                    quantity = quantity - 1;
                  });
                },
              ),
              SizedBox(width: getProportionateScreenWidth(8)),
              Text(
                '${quantity}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(width: getProportionateScreenWidth(8)),
              RoundedIconBtn(
                icon: Icons.add,
                showShadow: true,
                press: () {
                  setState(() {
                    quantity++;
                  });
                },
              ),
            ],
          );
  }
}
