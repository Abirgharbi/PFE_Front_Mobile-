import 'dart:convert';

import 'package:ARkea/ViewModel/order_controller.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:ARkea/ViewModel/signup_controller.dart';
import 'package:ARkea/Views/screens/checkOut/cart_screen.dart';

import 'package:ARkea/Views/screens/profil_page/profil_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../Model/product_model.dart';
import '../../ViewModel/login_controller.dart';
import '../../utils/colors.dart';
import '../../utils/shared_preferences.dart';
import 'Home/home_page.dart';
import 'package:badges/badges.dart' as badges;

import 'favorite_screen.dart';

final loginController = Get.put(LoginController());
final signUpController = Get.put(SignupScreenController());
final orderController = Get.put(OrderController());
final productController = Get.put(ProductController());

class LandingPage extends StatefulWidget {
  const LandingPage({super.key, this.yes});
  final bool? yes;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  // List<Product> addedProducts = [];
  // List<String> productsCart = [];
  // @override
  // void initState() {
  //   super.initState();
  //   getWhishlist();
  // }

  // getWhishlist() async {
  //   productsCart = await sharedPrefs.getStringList("cart");
  //   addedProducts =
  //       productsCart.map((e) => Product.fromJson(jsonDecode(e))).toList();
  //   setState(() {
  //     addedProducts = addedProducts;
  //   });
  // }

  int currentIndex = 0;

  static List<Widget> pages = [
    const HomeScreen(),
    CartScreen(),
    const favorite(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
        child: GNav(
          gap: 8,
          selectedIndex: currentIndex,
          onTabChange: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          activeColor: MyColors.btnBorderColor,
          tabBackgroundColor: Colors.grey.shade100,
          tabs: [
            const GButton(
              icon: Icons.home,
              text: "Home",
            ),
            GButton(
                icon: Icons.shopping_cart_outlined,
                text: "Cart",
                leading: Obx(
                  () => orderController.productCarts.isEmpty
                      ? const Icon(Icons.shopping_cart_outlined,
                          color: MyColors.btnBorderColor)
                      : badges.Badge(
                          position: badges.BadgePosition.topStart(
                              top: -12, start: -10),
                          badgeContent: Text(
                            orderController.productCarts.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Colors.red,
                            padding: const EdgeInsets.all(5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.shopping_cart_outlined,
                              color: MyColors.btnBorderColor),
                        ),
                )),
            GButton(
                icon: Icons.favorite_border_outlined,
                text: "Favorites",
                leading: Obx(
                  () => productController.wishlist.isEmpty
                      ? const Icon(Icons.favorite_border_outlined,
                          color: MyColors.btnBorderColor)
                      : badges.Badge(
                          position: badges.BadgePosition.topStart(
                              top: -12, start: -10),
                          badgeContent: Text(
                            productController.wishlist.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Colors.red,
                            padding: const EdgeInsets.all(5),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: const Icon(Icons.favorite_border_outlined,
                              color: MyColors.btnBorderColor),
                        ),
                )),
            const GButton(icon: Icons.person_outline, text: "Profile")
          ],
        ),
      ),
      body: pages[currentIndex],
    );
  }
}
