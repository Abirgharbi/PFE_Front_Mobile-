import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Model/product_model.dart';

import '../../../ViewModel/product_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/search_bar.dart';
import '../../widgets/product_card.dart';

class NewArrivalScreen extends StatefulWidget {
  const NewArrivalScreen({super.key});

  @override
  State<NewArrivalScreen> createState() => _NewArrivalScreenState();
}

class _NewArrivalScreenState extends State<NewArrivalScreen> {
  var productController = Get.put(ProductController());
  List<Product> filteredNewArrivalProductList = [];
  bool isFetching = false;
  bool isLoading = false;
  int page = 0;

  @override
  void initState() {
    super.initState();
    isFetching = true;
    filteredNewArrivalProductList = Get.arguments['recentProducts'];
  }

  void filterProducts(List<Product> productList) {
    setState(() {
      filteredNewArrivalProductList = productList;
      isFetching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'new arrival products',
      ),
      backgroundColor: const Color(0xFFF5F6F9),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            SearchBar(
              productList: filteredNewArrivalProductList,
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
                  : filteredNewArrivalProductList.isEmpty
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
                                  physics: const NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // Number of columns
                                    crossAxisSpacing: 16,
                                    mainAxisSpacing: 16,
                                    childAspectRatio: 1,
                                  ),
                                  itemCount:
                                      filteredNewArrivalProductList.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        filteredNewArrivalProductList[index];
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
                                    : (filteredNewArrivalProductList.length >=
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
                                                setState(() {
                                                  isLoading = true;
                                                });
                                                var res =
                                                    await productController
                                                        .getMostLikedProducts(
                                                            page);
                                                productController.length.value =
                                                    filteredNewArrivalProductList
                                                        .length;
                                                setState(() {
                                                  page++;
                                                  filteredNewArrivalProductList
                                                      .addAll(res);
                                                  isLoading = false;
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
                                              child: isLoading
                                                  ? const CircularProgressIndicator(
                                                      color: Colors.white,
                                                    )
                                                  : const Text(
                                                      "See More",
                                                      style: TextStyle(
                                                          fontSize: 20),
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
