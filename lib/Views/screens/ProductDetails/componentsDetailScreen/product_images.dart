import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/sizes.dart';
import 'package:flutter/material.dart';

import '../../../../Model/product_model.dart';

import '../../../../utils/sizes.dart';

class ProductImages extends StatefulWidget {
  const ProductImages({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  _ProductImagesState createState() => _ProductImagesState();
}

class _ProductImagesState extends State<ProductImages> {
  int selectedImage = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: AspectRatio(
            aspectRatio: 1,
            child: Hero(
              tag: widget.product.name.toString(),
              child: Image.network(widget.product.images[selectedImage]),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...List.generate(
                widget.product.images.length, (index) => productPreview(index)),
          ],
        )
      ],
    );
  }

  GestureDetector productPreview(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedImage = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        margin: const EdgeInsets.only(right: 15),
        padding: const EdgeInsets.all(8),
        height: (48),
        width: gWidth / 8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: MyColors.btnBorderColor
                  .withOpacity(selectedImage == index ? 1 : 0)),
        ),
        child: Image.network(widget.product.images[index]),
      ),
    );
  }
}
