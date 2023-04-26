import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/sizes.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  const CustomAppBar({Key? key});

  @override
  // AppBar().preferredSize.height provide us the height that appy on our app bar
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (40 / 375.0) * gWidth),
        child: Row(
          children: [
            SizedBox(
              height: (40 / 375.0) * gWidth,
              width: (40 / 375.0) * gWidth,
              child: TextButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    backgroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  ),
                  onPressed: () => Get.back(),
                  child: const Icon(Icons.arrow_back,
                      color: Colors.black, weight: 15)),
            ),
            const Spacer(),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
