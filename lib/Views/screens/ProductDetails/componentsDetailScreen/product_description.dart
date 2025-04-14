import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Model/product_model.dart';
import '../../../../ViewModel/product_controller.dart';

class ProductDescription extends StatefulWidget {
  ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  State<ProductDescription> createState() => _ProductDescriptionState();
}

class _ProductDescriptionState extends State<ProductDescription> {
  var productController = Get.put(ProductController());

  bool isLiked = false;
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gHeight / 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        if (widget.product.compareAtPrice != null)
                          Text(
                            '  \$${widget.product.compareAtPrice}',
                            style: const TextStyle(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                              fontSize: 14,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  widget.product.liked == true
                      ? productController.removeFromWishlist(widget.product)
                      : productController.addToWishlist(widget.product);
                  setState(() {
                    widget.product.liked == true
                        ? isLiked = false
                        : isLiked = true;
                  });
                },
                icon: Icon(
                  widget.product.liked == true
                      ? Icons.favorite // Filled heart
                      : Icons.favorite_border, // Outlined heart
                  size: 30,
                  color: widget.product.liked == true
                      ? Colors.red
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: EdgeInsets.only(
            left: gWidth / 20,
            right: gWidth / 20,
          ),
          child: AnimatedCrossFade(
            firstChild: Text(
              widget.product.description,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            secondChild: Text(
              widget.product.description,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ),
        if (widget.product.description.length > 50)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: gHeight / 20,
              vertical: 10,
            ),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Row(
                children: [
                  Text(
                    isExpanded ? "See Less" : "See More Detail",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.btnBorderColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: MyColors.btnBorderColor,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
