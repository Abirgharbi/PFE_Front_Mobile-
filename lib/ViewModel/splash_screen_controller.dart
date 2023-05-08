import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Views/screens/auth/login_page.dart';
import '../Views/screens/onBoardingscreen/boarding_page.dart';

class SplashScreenController extends GetxController {
  static SplashScreenController get find => Get.find();
  ProductController productController = Get.put(ProductController());
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    productController.getRecentProducts();
    productController.getMostLikedProducts();
  }

  RxBool animate = false.obs;
  bool? seenOnboard;
  Future startAnimation() async {
    WidgetsFlutterBinding.ensureInitialized();
    // to show status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
    // to load onboard for the first time only
    SharedPreferences pref = await SharedPreferences.getInstance();
    seenOnboard = pref.getBool('seenOnboard') ?? false;
    await Future.delayed(const Duration(milliseconds: 5000));

    animate.value = true;

    await Future.delayed(const Duration(milliseconds: 5000));
    Get.to(() => seenOnboard == true ? LandingPage() : boradingScreen());
  }
}
