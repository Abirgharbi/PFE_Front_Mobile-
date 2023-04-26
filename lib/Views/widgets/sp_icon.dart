import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SPIcon extends StatelessWidget {
  final String assetName;
  final bool isSelected;

  const SPIcon({super.key, required this.assetName, this.isSelected = false});
  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/$assetName",
      height: 25,
      width: 25,
      color: isSelected ? const Color(0xfffe416c) : MyColors.dummyBGColor,
    );
  }
}
