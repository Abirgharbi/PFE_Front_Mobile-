import 'package:ARkea/Views/screens/Home/categories.dart';
import 'package:ARkea/Views/screens/Home/filter_page.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../Model/product_model.dart';
import '../../../ViewModel/product_controller.dart';

import '../../../utils/colors.dart';
import '../../widgets/product_card.dart';
import '../../widgets/search_bar.dart';
import '../ProductDetails/newArrival_screen.dart';
import '../ProductDetails/popular_products_screen.dart';

var productController = Get.put(ProductController());

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> filteredProductList = [];

  @override
  void initState() {
    super.initState();
    filteredProductList = productController.mostLikedProductList +
        productController.recentProductsList;
  }

  void filterProducts(List<Product> productList) {
    setState(() {
      filteredProductList = productList;
      print(filteredProductList.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          SearchBar(
            productList: filteredProductList,
            onFilter: filterProducts,
          ),
          const SizedBox(
            height: 20,
          ),
          const Categories(),
          const SpecialOffers(),
          const SizedBox(
            height: 16,
          ),
          const NewArrivalSection(),
          const PopularProductSection(),
        ]));
  }
}

class PopularProductSection extends StatelessWidget {
  const PopularProductSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Popular",
          pressSeeAll: () => Get.toNamed("/popularProducts", arguments: {
            "mostLikedProducts": productController.mostLikedProductList,
          }),
          text: "See All",
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => productController.isLoading.value
                ? const CircularProgressIndicator()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        productController.mostLikedProductList.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ProductCard(
                                  product: productController
                                      .mostLikedProductList[index]),
                            )),
                  ),
          ),
        )
      ],
    );
  }
}

class NewArrivalSection extends StatelessWidget {
  const NewArrivalSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "New Arrival",
          text: "See All",
          pressSeeAll: () => Navigator.pushNamed(
            context,
            "/newProducts",
            arguments: {
              "recentProducts": productController.recentProductsList,
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Obx(
            () => productController.isLoading.value
                ? CircularProgressIndicator()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        productController.recentProductsList.length,
                        (index) => Padding(
                              padding: const EdgeInsets.only(right: 16),
                              child: ProductCard(
                                  product: productController
                                      .recentProductsList[index]),
                            )),
                  ),
          ),
        )
      ],
    );
  }
}

class SpecialOffers extends StatelessWidget {
  const SpecialOffers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Special for you",
          pressSeeAll: () {},
          text: "",
        ),
        SizedBox(height: gHeight / 50),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SpecialOfferCard(
                title: 'Summer Sale',
                discount: "Discount 20%",
                press: () {
                  Get.toNamed('/discount', arguments: {"discount": 20});
                },
              ),
              SpecialOfferCard(
                title: 'Stock Clearance',
                discount: "Discount 50%",
                press: () {
                  Get.toNamed('/discount', arguments: {"discount": 50});
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class SpecialOfferCard extends StatelessWidget {
  const SpecialOfferCard({
    Key? key,
    required this.discount,
    required this.title,
    required this.press,
  }) : super(key: key);

  final String discount, title;

  final GestureTapCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: gHeight / 20),
      child: GestureDetector(
        onTap: press,
        child: SizedBox(
          width: gWidth / 1.5,
          height: gHeight / 4,
          child: Card(
            elevation: 4, // Add elevation to create a shadow effect
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 108, 14, 175).withOpacity(0.8),
                        Color.fromARGB(255, 81, 3, 171).withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        discount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    required this.title,
    required this.pressSeeAll,
    this.text,
    super.key,
  });
  final String title;
  final String? text;
  final VoidCallback pressSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.w500),
        ),
        TextButton(
            onPressed: pressSeeAll,
            child: Text(
              text!,
              style: TextStyle(color: Colors.black54),
            ))
      ],
    );
  }
}

//LineIcons
const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none);
