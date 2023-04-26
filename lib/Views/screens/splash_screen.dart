import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ViewModel/splash_screen_controller.dart';
import '../../utils/sizes.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final splashController = Get.put(SplashScreenController());

  @override
  Widget build(BuildContext context) {
    splashController.startAnimation();
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Obx(
              () => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: splashController.animate.value ? -100 : -200,
                left: splashController.animate.value ? -50 : -90,
                child: const Image(
                  image: AssetImage("assets/images/topshape.png"),
                  height: 250,
                  width: 250,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
            Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                top: 100,
                left: splashController.animate.value ? tDefaultSize : -80,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 1600),
                  opacity: splashController.animate.value ? 1 : 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome To",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        "ARkea. \nHappy To Help",
                        style: Theme.of(context).textTheme.displayMedium,
                      )
                    ],
                  ),
                ))),
            Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 1600),
                bottom: splashController.animate.value ? 150 : 0,
                left: 80,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: splashController.animate.value ? 1 : 0,
                  child: const Image(
                    image: AssetImage("assets/images/logofinal.png"),
                    width: 300,
                  ),
                ))),
            Obx(() => AnimatedPositioned(
                duration: const Duration(milliseconds: 2400),
                bottom: splashController.animate.value ? 40 : 0,
                right: tDefaultSize,
                child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 2000),
                    opacity: splashController.animate.value ? 1 : 0,
                    child: Container(
                      width: tSplashContainerSize,
                      height: tSplashContainerSize,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Color(0xffFF7742),
                      ),
                    ))))
          ],
        ),
      ),
    );
  }
}
