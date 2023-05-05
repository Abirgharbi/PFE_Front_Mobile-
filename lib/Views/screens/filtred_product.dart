import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ViewModel/product_controller.dart';
import '../widgets/app_bar.dart';
import '../widgets/product_card.dart';

class FiltredProductScreen extends StatelessWidget {
  FiltredProductScreen({super.key});
  final ProductController productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: const CustomAppBar(title: 'Filtred Products'),
        body: Obx(() => productController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : productController.filtredProductsList.isEmpty
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
                    itemCount: productController.filtredProductsList.length,
                    itemBuilder: (context, index) {
                      final product =
                          productController.filtredProductsList[index];
                      return ProductCard(
                        product: product,
                      );
                    },
                  )));
  }
}
