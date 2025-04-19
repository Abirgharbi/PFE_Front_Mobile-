import 'dart:convert';

import 'package:arkea/ViewModel/CategoryComposite.dart';

import '../Model/category_model.dart';

import '../Model/service/network_handler.dart';
import 'package:get/get.dart';

class CategoryController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt productNumber = 0.obs;
  RxInt categoryNumber = 0.obs;


  List<Category> CategorieList = [];
  RxList<CategoryModel> categories = <CategoryModel>[].obs;

  late CategoryComposite allCategories;

  @override
  void onInit() {
    
    super.onInit();
    getCategories();
      allCategories = CategoryComposite(
      categories: [],
      isLoading: isLoading,
      categoryNumber: categoryNumber,
    );
    getAllCategories();
  }

    void getAllCategories() async {
    await allCategories.fetchData("category/all");
  }

// Sans Composite 

  // Future<void> fetchCategories() async {
  //   isLoading.value = true;
  //   var response = await NetworkHandler.get("category/all");
  //   var jsonData = json.decode(response);
  //   var data = jsonData['categories'] as List;
  //   categories.assignAll(data.map((e) => CategoryModel.fromJson(e)).toList());
  //   categoryNumber.value = categories.length;
  //   isLoading.value = false;
  // }

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
