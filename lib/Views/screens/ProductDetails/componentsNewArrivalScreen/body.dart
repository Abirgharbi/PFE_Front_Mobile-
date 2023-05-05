import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Model/product_model.dart';
import '../../../../ViewModel/product_controller.dart';
import '../../../../utils/sizes.dart';
import '../../../widgets/search_bar.dart';
import '../details_screen.dart';

var productController = Get.put(ProductController());

class Body extends StatefulWidget {
  List<Product> recentProductList;

  Body({Key? key, required this.recentProductList}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  RxBool done = false.obs;

  List<Product> filteredProductList = [];

  @override
  void initState() {
    super.initState();
    filteredProductList = widget.recentProductList;
  }

  void filterProducts(List<Product> productList) {
    setState(() {
      filteredProductList = productList;
      productController.length.value = filteredProductList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          SearchBar(
            productList: widget.recentProductList,
            onFilter: filterProducts,
          ),
          const SizedBox(
            height: 25,
          ),
          Obx(
            () => MasonryGridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 23,
              itemCount: productController.length.value,
              padding: const EdgeInsets.symmetric(
                horizontal: kPaddingHorizontal,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => Get.toNamed(
                    "/detail",
                    arguments: ProductDetailsArguments(
                        product: filteredProductList[index]),
                  ),
                  child: Container(
                    color: Color.fromARGB(
                      Random().nextInt(10),
                      Random().nextInt(10),
                      Random().nextInt(10),
                      Random().nextInt(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Positioned(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(kBorderRadius),
                                child: Image.network(
                                  filteredProductList[index].thumbnail,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              right: 12,
                              top: 12,
                              child: GestureDetector(
                                onTap: () {},
                                child: const Icon(
                                  LineAwesomeIcons.heart,
                                  size: 20,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                            filteredProductList[index].model != null
                                ? Positioned(
                                    left: 12,
                                    top: 12,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: const Icon(
                                        Icons.view_in_ar,
                                        size: 20,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  )
                                : Container()
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          filteredProductList[index].name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: kEncodeSansSemibold.copyWith(
                            color: kDarkBrown,
                            fontSize: gWidth / 100 * 3.5,
                          ),
                        ),
                        Text(
                          filteredProductList[index].description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kEncodeSansRagular.copyWith(
                            color: kGrey,
                            fontSize: gWidth / 100 * 2.5,
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "${filteredProductList[index].price}",
                              style: kEncodeSansSemibold.copyWith(
                                color: kDarkBrown,
                                fontSize: gWidth / 100 * 3.5,
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: kYellow,
                                  size: 16,
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  "${filteredProductList[index].ratingsAverage}",
                                  style: kEncodeSansRagular.copyWith(
                                    color: kDarkBrown,
                                    fontSize: gWidth / 100 * 3,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Obx(() => (productController.length ==
                  productController.recentProductNumber)
              ? Center(
                  child: SizedBox(
                      height: 20,
                      width: 100,
                      child: Text(
                        "No More products to load",
                        style: kEncodeSansSemibold.copyWith(
                          color: kDarkBrown,
                          fontSize: gWidth / 100 * 3.5,
                        ),
                      )),
                )
              : ElevatedButton(
                  onPressed: () => {
                        productController
                            .getMoreRecentProducts(widget.recentProductList),
                        productController.length.value =
                            widget.recentProductList.length,
                        print("hello")
                      },
                  child: const Text("See More"))),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}
