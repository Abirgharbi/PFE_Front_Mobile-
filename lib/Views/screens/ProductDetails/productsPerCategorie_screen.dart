import '../../../Model/category_model.dart';
import 'componentsNewArrivalScreen/custom_app_bar.dart';
import 'package:flutter/material.dart';

import 'componentsProductsPerCategorie/body.dart';

class productsPerCategorieScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CategorieDetailsArguments? agrs = ModalRoute.of(context)!
        .settings
        .arguments as CategorieDetailsArguments?;

    return Scaffold(
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFF5F6F9),
      body: Body(
        category: agrs!.category,
      ),
    );
  }
}

class CategorieDetailsArguments {
  final Category category;
  CategorieDetailsArguments({required this.category});
}
