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
  List<Product> productByCategoryList = [];
  int count = 0;
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  void getProductList() async {
    final product =
        await productController.getProductsByCategory(widget.category.id);

    final productList = product.products;
    count = product.count;
    print("=========================================");
    print(count);
    print("productList: $productList");
    setState(() {
      productByCategoryList = productList;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(count);
    return count == 0
        ? const Center(
            child: Text("No product found"),
          )
        : productController.isLoading.value
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
