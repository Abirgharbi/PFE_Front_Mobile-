import 'dart:convert';

import 'package:ARkea/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ARkea/ViewModel/product_controller.dart';

import '../../widgets/app_bar.dart';
import '../../widgets/product_card.dart';

class ProductsByCategory extends StatefulWidget {
  const ProductsByCategory({super.key});

  @override
  _ProductsByCategoryState createState() => _ProductsByCategoryState();
}

class _ProductsByCategoryState extends State<ProductsByCategory> {
  final productController = Get.put(ProductController());
  bool fetching = true;
  var category;
  List<Product>? productByCategoryList = [];

  @override
  void initState() {
    super.initState();
    category = Get.arguments['category'];
    getProductList(category.id);
  }

  void getProductList(String id) async {
    final product = await productController.getProductsByCategory(id);

    setState(() {
      fetching = false;
      productByCategoryList = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: category.name,
      ),
      body: SafeArea(
        child: fetching
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : productByCategoryList!.isEmpty
                ? const Center(
                    child: Text('No Products Found'),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1,
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: productByCategoryList!.length,
                    itemBuilder: (context, index) {
                      final product = productByCategoryList![index];
                      return ProductCard(
                        product: product,
                      );
                    },
                  ),
      ),
    );
  }
}
