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
    final image = NetworkHandler.getItem('customerImage') as String;
    final name = NetworkHandler.getItem('customerName') as String;

    var response = await NetworkHandler.post(
        '{"comment": "$comment", "rating": "$rating" ,"customerImage": "$image","customerName":"$name","productId": "$productId"}',
        "review/add");
    var res = await NetworkHandler.put(
        '{"rating": $rating}', "product/update-rating/$productId");
    print(res);
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
