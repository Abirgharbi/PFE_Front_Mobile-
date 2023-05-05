import 'package:ARkea/Views/screens/Home/categories.dart';
import 'package:ARkea/Views/screens/Home/filter_page.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../ViewModel/product_controller.dart';

import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/product_card.dart';
import '../ProductDetails/newArrival_screen.dart';
import '../ProductDetails/popular_products_screen.dart';

var productController = Get.put(ProductController());

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            padding: const EdgeInsets.all(16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  SizedBox(
                    height: 50,
                  ),
                  SearchForm(),
                  SizedBox(
                    height: 20,
                  ),
                  Categories(),
                  SpecialOffers(),
                  SizedBox(
                    height: 16,
                  ),
                  NewArrivalSection(),
                  PopularProductSection(),
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
                press: () {},
              ),
              SpecialOfferCard(
                image: "assets/images/Image Banner 2.png",
                category: "Fashion",
                discount: "Discount 50%%",
                press: () {},
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
                Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF343434).withOpacity(0.4),
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
                  child: Text.rich(
                    TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: "$category\n",
                          style: TextStyle(
                            fontSize: gHeight / 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: "$discount")
                      ],
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

//LineIcons
const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    borderSide: BorderSide.none);
