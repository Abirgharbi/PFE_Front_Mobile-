import 'package:ARkea/utils/colors.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../Model/product_model.dart';

import '../../../../utils/sizes.dart';

class ProductDescription extends StatelessWidget {
  const ProductDescription({
    Key? key,
    required this.product,
    this.pressOnSeeMore,
  }) : super(key: key);

  final Product product;
  final GestureTapCallback? pressOnSeeMore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: gHeight / 20),
          child: Text(
            product.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: EdgeInsets.all(gHeight / 50),
            width: gWidth / 8,
          ),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: gWidth / 20,
            right: gWidth / 20,
          ),
          child: Text(
            product.description,
            maxLines: 3,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: gHeight / 20,
            vertical: 10,
          ),
          child: GestureDetector(
            onTap: () {},
            child: Row(
              children: const [
                Text(
                  "See More Detail",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: MyColors.btnBorderColor),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: MyColors.btnBorderColor,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
