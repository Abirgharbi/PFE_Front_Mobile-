import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../Model/product_model.dart';

import '../../../../ViewModel/product_controller.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/sizes.dart';
import '../../Home/filter_page.dart';
import '../../Home/home_page.dart';
import '../details_screen.dart';

var productController = Get.put(ProductController());

class Body extends StatelessWidget {
  List<Product> mostLikedProductList;
  int length = productController.mostLikedProductList.length;

  RxBool done = false.obs;

  Body({Key? key, required this.mostLikedProductList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: ListView(
        children: [
          const SizedBox(
            height: 25,
          ),
          SearchForm(),
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
                  onTap: () => Navigator.pushNamed(
                    context,
                    "/detail",
                    arguments: ProductDetailsArguments(
                        product: mostLikedProductList[index]),
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
                                mostLikedProductList[index].thumbnail,
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
                          mostLikedProductList[index].model != null
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
                        mostLikedProductList[index].name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kEncodeSansSemibold.copyWith(
                          color: kDarkBrown,
                          fontSize: gWidth / 100 * 3.5,
                        ),
                      ),
                      Text(
                        mostLikedProductList[index].description,
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
                            "${mostLikedProductList[index].price}",
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
                                '5.0',
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
                );
              },
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Obx(
            () => productController.length == productController.productNumber
                ? Center(
                    child: SizedBox(
                        height: 20,
                        width: 100,
                        child: Text(
                          "No More",
                          style: kEncodeSansSemibold.copyWith(
                            color: kDarkBrown,
                            fontSize: gWidth / 100 * 3.5,
                          ),
                        )),
                  )
                : ElevatedButton(
                    onPressed: () => {
                          productController
                              .getMoreRecentProducts(mostLikedProductList),
                          productController.length.value =
                              mostLikedProductList.length,
                          print("${productController.length}" + "hello")
                        },
                    child: Text("See More")),
          )
        ],
      ),
    );
  }
}

class SearchForm extends StatelessWidget {
  const SearchForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
          decoration: InputDecoration(
        hintText: "Search items...",
        filled: true,
        fillColor: Colors.white,
        border: outlineInputBorder,
        enabledBorder: outlineInputBorder,
        focusedBorder: outlineInputBorder,
        contentPadding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        prefixIcon: const Icon(Icons.search, color: Colors.black),
        suffixIcon: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
              height: 48,
              width: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.btnColor.withOpacity(0.9),
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)))),
                onPressed: () {
                  Get.to(() => FilterPage());
                },
                child: SvgPicture.asset(
                  'assets/images/filter_icon.svg',
                ),
              )),
        ),
      )),
    );
  }
}
