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
      print(productList);
      filteredProductList = productList;
      print(filteredProductList);
      productController.popularLength.value = filteredProductList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
            ])));
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
          pressSeeAll: () => Navigator.pushNamed(
            context,
            "/popularProducts",
            arguments: PopularProductListArguments(
                productList: productController.mostLikedProductList),
          ),
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
            arguments: ProductListDetailsArguments(
                productList: productController.recentProductsList),
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
                image: "assets/images/Image Banner 2.png",
                category: "Tech",
                discount: "Discount 20%",
                press: () {
                  Get.toNamed('/discount', arguments: {"discount": 20});
                },
              ),
              SpecialOfferCard(
                image: "assets/images/Image Banner 2.png",
                category: "Fashion",
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
    required this.category,
    required this.image,
    required this.discount,
    required this.press,
  }) : super(key: key);

  final String category, image;
  final String discount;
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
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        MyColors.btnBorderColor.withOpacity(0.4),
                        Color(0xFF343434).withOpacity(0.15),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: gWidth / 20,
                    vertical: gHeight / 50,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(35.0),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(color: Colors.white),
                        children: [
                          TextSpan(
                            text: "$discount",
                            style: TextStyle(
                              fontSize: gHeight / 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ),
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
