import 'package:flutter/material.dart';

class SPSolidButton extends StatelessWidget {
  const SPSolidButton(
      {super.key,
      required this.text,
      this.onPressed,
      required this.minWidth,
      required this.backgroundColor});
  final String text;
  final Function()? onPressed;
  final num minWidth;
  final MaterialStateProperty<Color?> backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: backgroundColor,
          textStyle: MaterialStateProperty.all(
              const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600)),
          shape: MaterialStateProperty.all(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
