import 'dart:convert';
import 'package:arkea/Model/review_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:arkea/utils/shared_preferences.dart';

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
    final image = await sharedPrefs.getPref('customerImage');
    final name = await sharedPrefs.getPref('customerName');

    var response = await NetworkHandler.post(
        '{"comment": "$comment", "rating": "$rating" ,"customerImage": "$image","customerName":"$name","productId": "$productId"}',
        "review/add");
    print('---------');
    print(response);
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
