import 'package:flutter/material.dart';

import '../../../Model/product_model.dart';
import 'componentsDetailScreen/body.dart';
import 'componentsDetailScreen/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments? agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments?;

    return Scaffold(
      appBar: CustomAppBar(
          rating: agrs!.product.ratingsAverage,
          thumbnail: agrs.product.thumbnail,
          productId: agrs.product.id
          ),
      backgroundColor: const Color(0xFFF5F6F9),
      body: Body(product: agrs.product),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
