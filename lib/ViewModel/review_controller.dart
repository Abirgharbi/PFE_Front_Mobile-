import 'dart:convert';
import 'package:ARkea/Model/review_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../Model/service/network_handler.dart';

class ReviewController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt count = 0.obs;
  List<Review> reviewsList = [];

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  addReview(String comment, double rating, String productId) async {
    isLoading(true);
    var response = await NetworkHandler.post(
        // i need to get customerimge and name from the current user
        '{"comment": "$comment", "rating": "$rating" ,"customerImage": "https://res.cloudinary.com/dbkivxzek/image/upload/v1682574096/ARkea/wz2ey0i5bf72l4n7vaqp.jpg","customerName":"ilyes BHD","productId": "$productId"}',
        "review/add");
    isLoading(false);
  }

  getProductReviews(String productId) async {
    isLoading(true);
    var response = await NetworkHandler.get("review/product/$productId");
    ReviewModel reviewModel = ReviewModel.fromJson(json.decode(response));
    reviewsList = reviewModel.reviews;
    count.value = reviewModel.count;
    isLoading(false);
  }
}
