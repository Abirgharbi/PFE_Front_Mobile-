import 'package:ARkea/Views/screens/splash_screen.dart';

import 'Views/screens/ProductDetails/popular_products_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_framework/responsive_wrapper.dart';

import 'ViewModel/bindings.dart';
import 'Views/screens/Home/home_page.dart';
import 'Views/screens/ProductDetails/details_screen.dart';
import 'Views/screens/ProductDetails/newArrival_screen.dart';
import 'Views/screens/ProductDetails/products_by_categories.dart';
import 'Views/screens/about_us.dart';
import 'Views/screens/auth/login_page.dart';
import 'Views/screens/auth/signup.dart';
import 'Views/screens/checkOut/cart_screen.dart';
import 'Views/screens/discount.dart';
import 'Views/screens/filtred_product.dart';
import 'Views/screens/help_center.dart';
import 'Views/screens/landing_page.dart';
import 'Views/screens/profil_page/noLoggedIn_profilPage.dart';
import 'Views/screens/profil_page/profil_page.dart';
import 'Views/screens/review/add-review.dart';
import 'Views/screens/review/review.dart';
import 'Views/screens/side_menu.dart';
import 'utils/text_theme.dart';
import '.env.dart';
import 'Views/screens/profil_page/AddressScreen.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) => ResponsiveWrapper.builder(
        child,
        maxWidth: 1200,
        minWidth: 480,
        defaultScale: true,
        breakpoints: [
          const ResponsiveBreakpoint.resize(480, name: MOBILE),
          const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          const ResponsiveBreakpoint.resize(1000, name: DESKTOP),
        ],
      ),
      title: "ARkea",
      theme: ThemeData(
          textTheme: TTtextTheme.lightTextTheme,
          brightness: Brightness.light,
          fontFamily: "Gordita"),
      darkTheme: ThemeData(
          brightness: Brightness.dark, textTheme: TTtextTheme.darkTextTheme),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      initialRoute: "/splash",
      initialBinding: MyBindings(),
      getPages: [
        GetPage(
          name: '/landing',
          page: () => const LandingPage(),
          transition: Transition.leftToRightWithFade,
          transitionDuration: const Duration(milliseconds: 500),
        ),
        GetPage(name: '/home', page: () => const HomeScreen()),
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/signup', page: () => const SignUp()),
        GetPage(name: '/profil', page: () => ProfileScreen()),
        GetPage(name: '/detail', page: () => DetailsScreen()),
        GetPage(name: '/SideMenu', page: () => const SideMenu()),
        GetPage(name: '/newProducts', page: () => const NewArrivalScreen()),
        GetPage(
            name: '/popularProducts', page: () => const PopularProductScreen()),
        GetPage(
            name: '/productsPerCategorie',
            page: () => const ProductsByCategory()),
        GetPage(
            name: '/noLoggedInprofil',
            page: () => const noLoggedIn_profilPage()),
        GetPage(name: '/cart', page: () => CartScreen()),
        GetPage(name: '/review', page: () => ReviewScreen()),
        GetPage(name: '/add-review', page: () => const AddReviewScreen()),
        GetPage(name: '/filtredProducts', page: () => FiltredProductScreen()),
        GetPage(name: '/address', page: () => const AddressScreen()),
        GetPage(name: '/discount', page: () => const DiscountScreen()),
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/about', page: () => const AboutUsScreen()),
        GetPage(name: '/help', page: () => const HelpCenterScreen()),
      ],
      home: SplashScreen(),
    );
  }
}
