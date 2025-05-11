import 'dart:convert';
import 'package:arkea/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/service/network_handler.dart';
import '../utils/shared_preferences.dart';
import 'component.dart';


class CategoryComposite extends DataComposite {
  List<CategoryModel> categories; // Les données locales de cette composite
  RxInt categoryNumber;
  List<DataComposite> subComponents = []; // Récursivité

  CategoryComposite({
    required this.categories,
    required this.categoryNumber,
  });

  @override
  Future<void> fetchData(String endpoint) async {
    try {
      isLoading.value = true;

      final response = await NetworkHandler.get(endpoint);
      final jsonData = json.decode(response);
      final data = jsonData['categories'] as List;

      categories.clear();
      subComponents.clear();

      for (var categoryJson in data) {
        final category = CategoryModel.fromJson(categoryJson);
        categories.add(category);

        // Création d’un sous-composite pour chaque sous-catégorie (récursif)
        final subComposite = CategoryComposite(
          categories: [],
          categoryNumber: 0.obs,
        );

        // Optionnel : endpoint dynamique basé sur l'id
        final subEndpoint = "/categories/${categoryNumber}";

        await subComposite.fetchData(subEndpoint);
        subComponents.add(subComposite);
      }

      categoryNumber.value = categories.length;
    } finally {
      isLoading.value = false;
    }
  }
}
