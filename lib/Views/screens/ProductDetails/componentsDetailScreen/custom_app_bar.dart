import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../ViewModel/review_controller.dart';
import '../../../../utils/sizes.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  final double rating;
  final String productId;

  CustomAppBar({required this.rating,required this.productId, Key? key}) : super(key: key);

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
                  arguments: {
                    'imageUrl':
                        'https://res.cloudinary.com/dbkivxzek/image/upload/v1681557790/ARkea/moo8hs2jle9evi5u8o1z.png',
                    'reviews': [
                      {
                        'userName': 'ilyes bhd',
                        'userImage':
                            'https://res.cloudinary.com/dbkivxzek/image/upload/v1681427867/ARkea/slmxeqmrbjxth5cgfwtu.jpg',
                        'comment': 'This is a great product!',
                        'rating': 4.5,
                      },
                      {
                        'userName': 'ilyes bhd',
                        'userImage':
                            'https://res.cloudinary.com/dbkivxzek/image/upload/v1681427867/ARkea/slmxeqmrbjxth5cgfwtu.jpg',
                        'comment': 'Not what I expected.',
                        'rating': 2.0,
                      },
                      {
                        'userName': 'ilyes bhd',
                        'userImage':
                            'https://res.cloudinary.com/dbkivxzek/image/upload/v1681427867/ARkea/slmxeqmrbjxth5cgfwtu.jpg',
                        'comment': 'This is a great product!',
                        'rating': 4.5,
                      },
                      {
                        'userName': 'ilyes bhd',
                        'userImage':
                            'https://res.cloudinary.com/dbkivxzek/image/upload/v1681427867/ARkea/slmxeqmrbjxth5cgfwtu.jpg',
                        'comment':
                            'This is a great product! This is a great product! This is a great product! This is a great product! ',
                        'rating': 4.5,
                      },
                      {
                        'userName': 'ilyes bhd',
                        'userImage':
                            'https://res.cloudinary.com/dbkivxzek/image/upload/v1681427867/ARkea/slmxeqmrbjxth5cgfwtu.jpg',
                        'comment': 'This is a great product!',
                        'rating': 4.5,
                      },
                    ],
                  },
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
                      "$rating",
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
