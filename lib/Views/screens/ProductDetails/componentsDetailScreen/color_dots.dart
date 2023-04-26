import 'package:ARkea/utils/colors.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:string_to_color/string_to_color.dart';

import '../../../../Model/product_model.dart';

import '../../../../utils/sizes.dart';
import '../../../widgets/rounded_icon_btn.dart';

class ColorImage extends StatefulWidget {
  const ColorImage({
    Key? key,
    this.color,
    this.isSelected = false,
    required this.product,
  });
  final Color? color;
  final bool isSelected;
  final Product product;

  @override
  State<ColorImage> createState() => ColorImageState();
}

class ColorImageState extends State<ColorImage> {
  int selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: gHeight / 20),
      child: Row(
        children: [
          ...List.generate(
              widget.product.colors.length,
              (index) => productPreview(index,
                  ColorUtils.stringToColor(widget.product.colors[index]))),
          Spacer(),
          addQuantityWidget(),
        ],
      ),
    );
  }

  GestureDetector productPreview(int index, Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedColor = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.only(right: 2),
        padding: EdgeInsets.all((8 / 375.0) * gWidth),
        height: (40 / 375.0) * gWidth,
        width: (40 / 375.0) * gWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
              color: MyColors.btnBorderColor
                  .withOpacity(selectedColor == index ? 1 : 0)),
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            border: Border.all(
                color: widget.isSelected
                    ? MyColors.btnBorderColor
                    : Colors.transparent),
            shape: BoxShape.circle,
          ),
        ),
      ),

      //widget.product.images[index]
    );
  }
}

class addQuantityWidget extends StatefulWidget {
  const addQuantityWidget({super.key});

  @override
  State<addQuantityWidget> createState() => _addQuantityWidgetState();
}

class _addQuantityWidgetState extends State<addQuantityWidget> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RoundedIconBtn(
          icon: Icons.remove,
          press: () {
            setState(() {
              if (quantity > 1) quantity--;
            });
          },
        ),
        SizedBox(width: getProportionateScreenWidth(8)),
        Text(
          '$quantity',
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
