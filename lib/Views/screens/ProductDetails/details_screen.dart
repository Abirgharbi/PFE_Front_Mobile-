import 'package:flutter/material.dart';

import '../../../Model/product_model.dart';
import 'componentsDetailScreen/body.dart';
import 'componentsDetailScreen/custom_app_bar.dart';

class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductDetailsArguments? agrs =
        ModalRoute.of(context)!.settings.arguments as ProductDetailsArguments?;

    print(agrs!.product.ratingsAverage);
    return Scaffold(
      // appBar: const CustomAppBar(rating: agrs.product.ratingsAverage ), // use this line when changing rating average in product model and db and backend to double

      appBar: CustomAppBar(rating: 3.5, productId: agrs.product.id),
      backgroundColor: const Color(0xFFF5F6F9),
      body: Body(product: agrs!.product),
    );
  }
}

class ProductDetailsArguments {
  final Product product;

  ProductDetailsArguments({required this.product});
}
