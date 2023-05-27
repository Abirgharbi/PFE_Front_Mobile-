import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../Model/product_model.dart';
import '../../ViewModel/product_controller.dart';
import '../screens/ProductDetails/details_screen.dart';
import 'package:get/get.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    required this.product,
    super.key,
  });
  final Product product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

bool isLiked = false;
var productController = Get.put(ProductController());

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          "/detail",
          arguments: ProductDetailsArguments(product: widget.product),
        );
      },
      child: Container(
        width: 154,
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Color(0xFFEFEFF2),
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Image.network(
                      widget.product.thumbnail,
                      height: 124,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () {
                      print("tapped");
                      print(widget.product.liked);
                      print(widget.product);
                      widget.product.liked == true
                          ? productController.removeFromWishlist(widget.product)
                          : productController.addToWishlist(widget.product);
                      setState(() {
                        widget.product.liked == true
                            ? isLiked = false
                            : isLiked = true;
                      });
                    },
                    child: SizedBox(
                      width: 35,
                      height: 35,
                      child: Icon(
                        widget.product.liked == true
                            ? LineAwesomeIcons.heart_1
                            : LineAwesomeIcons.heart,
                        size: 20,
                        color: widget.product.liked == true
                            ? Colors.red
                            : Colors.black54,
                      ),
                    ),
                  ),
                ),
                widget.product.model != null
                    ? Positioned(
                        top: 0,
                        left: 0,
                        child: InkWell(
                          onTap: () {},
                          child: const SizedBox(
                            width: 35,
                            height: 35,
                            child: Icon(
                              Icons.view_in_ar,
                              size: 20,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                      )
                    : Container()
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product.name,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall!
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '\$${widget.product.compareAtPrice}\n',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      TextSpan(
                        text: '\$${widget.product.price}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
