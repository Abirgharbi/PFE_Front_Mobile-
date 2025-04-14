import 'package:arkea/ViewModel/product_controller.dart';
import 'package:arkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/screens/onBoardingscreen/boarding_page.dart';

class SplashScreenController extends GetxController {
  
  static SplashScreenController get find => Get.find();
  ProductController productController = Get.put(ProductController());
  @override
  void onInit() {
    super.onInit();
    productController.getRecentProducts();
    productController.getMostLikedProducts(0);
  }

  RxBool animate = false.obs;
  bool? seenOnboard;
  Future startAnimation() async {
    WidgetsFlutterBinding.ensureInitialized();

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

    SharedPreferences pref = await SharedPreferences.getInstance();
    seenOnboard = pref.getBool('seenOnboard') ?? false;

    animate.value = true;

    await Future.delayed(const Duration(milliseconds: 3000));
    Get.to(() =>
        seenOnboard == true ? const LandingPage() : const boradingScreen());
  }
}
