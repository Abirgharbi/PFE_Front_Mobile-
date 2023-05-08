import 'package:flutter/material.dart';

import '../../../Model/product_model.dart';

import 'componentsNewArrivalScreen/custom_app_bar.dart';
import 'componentsPopularProductsScreen/body.dart';

class PopularProductScreen extends StatelessWidget {
  const PopularProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final PopularProductListArguments? agrs = ModalRoute.of(context)!
        .settings
        .arguments as PopularProductListArguments?;
    return Scaffold(
        appBar: const CustomAppBar(),
        backgroundColor: const Color(0xFFF5F6F9),
        body: Body(
          mostLikedProductList: agrs!.productList,
        ));
  }
}

class PopularProductListArguments {
  final List<Product> productList;

  PopularProductListArguments({required this.productList});
}
