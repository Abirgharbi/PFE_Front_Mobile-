import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Model/product_model.dart';
import '../../ViewModel/product_controller.dart';
import '../widgets/app_bar.dart';
import '../widgets/product_card.dart';

class DiscountScreen extends StatefulWidget {
  const DiscountScreen({super.key});

  @override
  State<DiscountScreen> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends State<DiscountScreen> {
  final ProductController productController = Get.put(ProductController());
  bool fetching = false;
  @override
  void initState() {
    super.initState();
    getProductList();
  }

  List<Product> discountedProducts = [];
  final int discount = Get.arguments['discount'];

  void getProductList() async {
    setState(() {
      fetching = true;
    });
    final product = await productController.getDiscountedProducts(discount);
    setState(() {
      fetching = false; 
      discountedProducts = product;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'discounted Products'),
      body: fetching
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : discountedProducts.isEmpty
              ? const Center(
                  child: Text('No Products Found'),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: discountedProducts.length,
                  itemBuilder: (context, index) {
                    final product = discountedProducts[index];
                    return ProductCard(
                      product: product,
                    );
                  },
                ),
    );
  }
}
