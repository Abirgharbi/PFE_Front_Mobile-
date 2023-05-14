import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/product_model.dart';

import '../../../ViewModel/product_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/product_card.dart';

class PopularProductScreen extends StatefulWidget {
  const PopularProductScreen({super.key});

  @override
  State<PopularProductScreen> createState() => _PopularProductScreenState();
}

class _PopularProductScreenState extends State<PopularProductScreen> {
  var productController = Get.put(ProductController());
  List<Product> filteredPopularProductList = [];
  bool fetching = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    fetching = true;
    filteredPopularProductList = Get.arguments['mostLikedProducts'];
  }

  void filterProducts(List<Product> productList) {
    setState(() {
      filteredPopularProductList = productList;
      fetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'popular products',
      ),
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SearchBar(
              productList: filteredPopularProductList,
              onFilter: filterProducts,
            ),
            const SizedBox(
              height: 15,
            ),
            Obx(
              () => productController.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : filteredPopularProductList.isEmpty
                      ? const Center(
                          child: Text('No Products Found'),
                        )
                      : Expanded(
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Expanded(
                                child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount: filteredPopularProductList.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        filteredPopularProductList[index];
                                    return ProductCard(
                                      product: product,
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Obx(
                                () => productController.isLoading.value
                                    ? Container()
                                    : (filteredPopularProductList.length >=
                                            productController
                                                .popularProductNumber.value)
                                        ? Center(
                                            child: SizedBox(
                                                height: 20,
                                                width: 100,
                                                child: Text(
                                                  "No More products to load",
                                                  style: kEncodeSansSemibold
                                                      .copyWith(
                                                    color: kDarkBrown,
                                                    fontSize:
                                                        gWidth / 100 * 3.5,
                                                  ),
                                                )),
                                          )
                                        : Container(
                                            width: gWidth / 2,
                                            padding: const EdgeInsets.all(10),
                                            child: ElevatedButton(
                                              onPressed: () async {
                                                var res =
                                                    await productController
                                                        .getMostLikedProducts(
                                                            page);
                                                productController.length.value =
                                                    filteredPopularProductList
                                                        .length;
                                                print(filteredPopularProductList
                                                    .length);
                                                setState(() {
                                                  page++;
                                                  filteredPopularProductList
                                                      .addAll(res);
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                fixedSize: const Size(50, 50),
                                                backgroundColor:
                                                    MyColors.btnColor,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text(
                                                "See More",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            ),
                                          ),
                              ),
                            ],
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
