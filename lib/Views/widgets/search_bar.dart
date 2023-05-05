import 'package:flutter/material.dart';
import 'package:ARkea/Views/screens/Home/filter_page.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Model/product_model.dart';
import '../../ViewModel/product_controller.dart';
import '../../utils/colors.dart';
import '../screens/Home/home_page.dart';

class SearchBar extends StatefulWidget {
  final List<Product> productList;
  final void Function(List<Product>) onFilter;

  const SearchBar({
    Key? key,
    required this.productList,
    required this.onFilter,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _filteredProductList = [];
  double _rating = 4;
  ProductController _productController = Get.put(ProductController());
  @override
  void initState() {
    super.initState();
    _filteredProductList = widget.productList;
  }

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
                    // Get.to(() => FilterPage());
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 30),
                            child: Column(children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Filter",
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        Get.back();
                                      },
                                      icon: const Icon(
                                        Icons.clear,
                                        size: 30,
                                      ))
                                ],
                              ),
                              const Divider(),
                              const SizedBox(
                                height: 50,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: RatingBar.builder(
                                        initialRating: 4,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                        ),
                                        onRatingUpdate: (rating) {
                                          setState(() {
                                            _rating = rating;
                                            print(_rating);
                                          });
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          "Price Range",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          "\$${rangeValue.start.toStringAsFixed(0)}-${rangeValue.end.toStringAsFixed(0)}",
                                          selectionColor:
                                              MyColors.btnBorderColor,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RangeSlider(
                                          activeColor: MyColors.btnBorderColor,
                                          inactiveColor: Colors.grey,
                                          min: 0,
                                          max: 300,
                                          values: rangeValue,
                                          onChanged: (s) {
                                            setState(() {
                                              rangeValue = s;
                                            });
                                          },
                                          onChangeEnd: (s) {
                                            setState(() {
                                              rangeValue = s;
                                              print(rangeValue);
                                            });
                                          },
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    Center(
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: MyColors.btnBorderColor,
                                          border: Border.all(
                                            color: MyColors.btnBorderColor,
                                            width: 1 / 2,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(25),
                                        ),
                                        child: InkWell(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          onTap: () {
                                            _productController
                                                .getFiltredProducts(
                                                    rangeValue, _rating);
                                            Get.toNamed('/filtredProducts');
                                          },
                                          splashColor: MyColors.btnBorderColor,
                                          child: const Center(
                                            child: Text(
                                              "Apply Filter",
                                              style: TextStyle(
                                                fontSize: 18,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ]));
                      },
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/images/filter_icon.svg',
                  ),
                )),
          ),
        ),
        onChanged: (value) {
          setState(() {
            _filteredProductList = widget.productList
                .where((product) =>
                    product.name.toLowerCase().contains(value.toLowerCase()))
                .toList();
          });
          widget.onFilter(_filteredProductList);
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  RangeValues rangeValue = const RangeValues(0.0, 300);
}
