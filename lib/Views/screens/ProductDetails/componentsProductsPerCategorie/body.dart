// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:ARkea/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:ARkea/ViewModel/product_controller.dart';

import '../../../../Model/category_model.dart';
import '../../../widgets/product_card.dart';

class Body extends StatefulWidget {
  final Category category;

  const Body({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final productController = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  bool fetched = false;
  List<Product> productByCategoryList = <Product>[];
  void getProductList() async {
    final product =
        await productController.getProductsByCategory(widget.category.id);

    final productList = product.products;
    fetched = true;

    setState(() {
      productByCategoryList = productList;
      fetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return productByCategoryList.isEmpty && fetched == true
        ? const Center(
            child: Text("No product found"),
          )
        : !fetched
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: productByCategoryList.length,
                itemBuilder: (context, index) {
                  final product = productByCategoryList[index];
                  return ProductCard(
                    product: product,
                  );
                },
              );
  }
}

final productController = Get.put(ProductController());

//LineIcons
const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none);
