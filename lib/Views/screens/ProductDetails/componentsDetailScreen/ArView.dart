import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:flutter/material.dart';

import '../../../../Model/product_model.dart';

class ArScreen extends StatelessWidget {
  final Product product;

  const ArScreen({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(
        child: AspectRatio(
          aspectRatio: 1,
          child: Hero(
            tag: product.name.toString(),
            child: ModelViewer(
              src: product.model!,
              alt: "A 3D model of an astronaut",
              ar: true,
              arModes: ['scene-viewer', 'webxr', 'quick-look'],
              autoRotate: true,
              cameraControls: true,
              arPlacement: ArPlacement.floor,
            ),
            // widget.product.images[selectedImage]
          ),
        ),
      ),
    ]);
  }
}
