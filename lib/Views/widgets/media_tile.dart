import 'package:flutter/material.dart';

class MediaTile extends StatelessWidget {
  const MediaTile(
      {super.key,
      required this.imagePath,
      required this.size,
      required this.onPress});
  final String imagePath;
  final double size;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return
        ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(24),
      ),
      child: Image.asset(
        imagePath,
        height: size,
      ),
    );
  }
}
