import 'package:arkea/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../ViewModel/category_controller.dart';
import '../../../utils/sizes.dart';

var categorieController = Get.put(CategoryController());

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Obx(
          () => categorieController.isLoading.value
              ? const CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                    categorieController.CategorieList.length,
                    (index) => CategoryCard(
                      category: categorieController.CategorieList[index],
                    ),
                  ),
                ),
        ));
  }
}

class CategoryCard extends StatelessWidget {
  CategoryCard(
      {Key? key,
      // required this.icon,
      // required this.text,
      required this.category})
      : super(key: key);

  // final String icon, text;

  final Category category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => {
          print(category.name),
          Get.toNamed('/productsPerCategorie',
              arguments: {"category": category}),
        },
        child: SizedBox(
          // width: gWidth,
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(gWidth / 20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFECDF),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(
                  category.image,
                  height: 50,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                category.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(category.name, textAlign: TextAlign.center)
            ],
          ),
        ),
      ),
    );
  }
}
