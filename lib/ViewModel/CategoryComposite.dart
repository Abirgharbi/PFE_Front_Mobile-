import 'dart:convert';
import 'package:arkea/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import '../utils/shared_preferences.dart';
import 'component.dart';



class CategoryComposite extends IDataComposite {
  
  List<CategoryModel> categories;
  RxBool isLoading;
  RxInt categoryNumber;

  CategoryComposite({
    required this.categories,
    required this.isLoading,
    required this.categoryNumber,
  });

  
  @override
  Future<void> fetchData(String endpoint)  async {
    try {
      isLoading.value = true;
      final response = await NetworkHandler.get(endpoint);
      final jsonData = json.decode(response);
      final data = jsonData['categories'] as List;
      categories.clear();
      categories.addAll(data.map((e) => CategoryModel.fromJson(e)).toList());
      categoryNumber.value = categories.length;
    } finally {
      isLoading.value = false;
    }
}
}

