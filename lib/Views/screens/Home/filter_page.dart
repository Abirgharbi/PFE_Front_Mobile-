import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../../ViewModel/product_controller.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _rating = 4;
  ProductController _productController = Get.put(ProductController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.scaffoldBGColor,
      body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Filter",
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                IconButton(
                    onPressed: () {
                      Get.toNamed('/landing');
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Price Range",
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        "\$${rangeValue.start.toStringAsFixed(0)}-${rangeValue.end.toStringAsFixed(0)}",
                        selectionColor: MyColors.btnBorderColor,
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
                      width: MediaQuery.of(context).size.width / 2,
                      height: 50,
                      decoration: BoxDecoration(
                        color: MyColors.btnBorderColor,
                        border: Border.all(
                          color: MyColors.btnBorderColor,
                          width: 1 / 2,
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(15),
                        onTap: () {
                          _productController.getFiltredProducts(
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
          ])),
      // ),
    );
  }

  RangeValues rangeValue = const RangeValues(0.0, 300);
}
