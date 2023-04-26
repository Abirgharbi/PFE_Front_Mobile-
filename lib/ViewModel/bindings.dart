import 'profile_controller.dart';
import 'signup_controller.dart';
import 'splash_screen_controller.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class MyBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignupScreenController>(() => SignupScreenController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
