import 'dart:convert';
import 'package:ARkea/Model/review_model.dart';
import 'package:get/get.dart';

import '../Model/service/network_handler.dart';

class ReviewController extends GetxController {
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  addReview(String comment, double rating) async {
    isLoading(true);
    var response = await NetworkHandler.post(
        '{"comment": "$comment", "rating": "$rating" ,"customerId": "642ce9a576f26219f9f910ca","productId": "643a891f8ab9ec1621244025"     }',
        "review/add");

    print("this the add review response $response");
    isLoading(false);
  }
  getProductReviews(String productId) async {
    isLoading(true);
    var response = await NetworkHandler.get("review/product/$productId");
    ReviewModel reviewModel = ReviewModel.fromJson(json.decode(response));

    print("this the get product reviews response $response");
    getCustomerReviews(reviewModel.reviews.customerId);
    isLoading(false);

  }

  getCustomerReviews(String customerId) async {
    isLoading(true);
    var response = await NetworkHandler.get("review/customer/$customerId");
    print("this the get customer reviews response $response");
    isLoading(false);
  }

}
