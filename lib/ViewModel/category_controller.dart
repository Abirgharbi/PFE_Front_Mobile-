import 'dart:convert';

import '../Model/category_model.dart';

import '../Model/service/network_handler.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt productNumber = 0.obs;

  List<Category> CategorieList = [];

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  getCategories() async {
    isLoading(true);
    var response = await NetworkHandler.get("product/category/get");
    CategoryModel categorieModel =
        CategoryModel.fromJson(json.decode(response));
    CategorieList = categorieModel.categories;
    isLoading(false);
    print(CategorieList);
    return CategorieList;
  }
}

//}
