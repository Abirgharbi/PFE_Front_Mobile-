import 'package:arkea/Views/screens/landing_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../utils/sizes.dart';

class Success extends StatelessWidget {
  const Success({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: gHeight * 0.04),
        Image.asset(
          "assets/images/success.png",
          height: gHeight * 0.4,
        ),
        SizedBox(height: gHeight * 0.08),
        const Text(
          "Login Success",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: MyColors.btnColor,
            elevation: 0,
          ),
          onPressed: () {
            Get.to(() => const LandingPage());
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                // SizedBox(
                //   width: 8,
                // ),
                Text("Back to home")
              ],
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
