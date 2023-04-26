import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class SPTextButton extends StatelessWidget {
  const SPTextButton({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () {},
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 60),
          width: MediaQuery.of(context).size.width,
          child: Text(
            text,
            style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: MyColors.heading6),
          ),
        ),
      ),
    );
  }
}
