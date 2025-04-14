import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import '../utils/shared_preferences.dart';

class ProductComposite {
  
  List<ProductModel> products;
  RxBool isLoading;
  RxInt productNumber;

  ProductComposite({
    required this.products,
    required this.isLoading,
    required this.productNumber,
  });

  Future<void> fetchProducts(String endpoint) async {
    try {
      isLoading.value = true;
      final response = await NetworkHandler.get(endpoint);
      final jsonData = json.decode(response);
      final data = jsonData['products'] as List;
      products.clear();
      products.addAll(data.map((e) => ProductModel.fromJson(e)).toList());
      productNumber.value = products.length;
    } finally {
      isLoading.value = false;
    }
  }
}
