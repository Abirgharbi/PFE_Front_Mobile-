import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/product_model.dart';

import '../../../ViewModel/product_controller.dart';
import 'componentsNewArrivalScreen/body.dart';
import 'componentsNewArrivalScreen/custom_app_bar.dart';

class NewArrivalScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final ProductListDetailsArguments? agrs = ModalRoute.of(context)!
        .settings
        .arguments as ProductListDetailsArguments?;
    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFF5F6F9),
      body: Body(
        recentProductList: agrs!.productList,
      ),
    );
  }
}

class ProductListDetailsArguments {
  final List<Product> productList;

  ProductListDetailsArguments({required this.productList});
}
