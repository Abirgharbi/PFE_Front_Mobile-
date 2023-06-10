import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../ViewModel/review_controller.dart';
import '../../../../utils/sizes.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final double rating;
  final String thumbnail;
  final String productId;

  CustomAppBar(
      {required this.rating,
      required this.thumbnail,
      required this.productId,
      Key? key})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);

  ReviewController _reviewController = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: (20 / 375.0) * gWidth),
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
            GestureDetector(
              onTap: () {
                _reviewController.getProductReviews(productId);
                Get.toNamed(
                  '/review',
                  arguments: [
                    {'thumbnail': thumbnail},
                    {'productId': productId}
                  ],
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Text(
                      "${rating.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 2),
                      child: Icon(
                        Icons.star,
                        color: Colors.yellow,
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
