import 'dart:convert';

import 'package:flutter/material.dart';

import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt countPopular = 0.obs;
  RxInt count = 0.obs;
  RxInt countRecent = 0.obs;
  RxInt length = 5.obs;
  RxInt productNumber = 0.obs;
  RxInt popularProductNumber = 0.obs;
  RxInt recentProductNumber = 0.obs;

  var product = 0.obs;

  List<Product> productList = [];
  List<Product> productByCategoryList = [];
  List<Product> mostLikedProductList = [];
  List<Product> recentProductsList = [];
  List<Product> filtredProductsList = [];
  List<Product> discountedProductsList = [];

  @override
  void onInit() {
    super.onInit();
    getRecentProducts();
    getProductDetails();
    getMostLikedProducts(0);
  }

  getRecentProducts() async {
    isLoading(true);
    var response = await NetworkHandler.get("product/recent?page=0");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    recentProductsList = productModel.products;
    recentProductNumber.value = productModel.count;
    isLoading(false);

    return recentProductsList;
  }

  getMoreRecentProducts(List<Product> list) async {
    countRecent.value = countRecent.value + 1;

    var response = await NetworkHandler.get("product/recent?page=$countRecent");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    list.addAll(productModel.products);
    length.value = list.length;
  }

  getMostLikedProducts(int page) async {
    // isLoading(true);
    countPopular.value = countPopular.value + 1;
    var response = await NetworkHandler.get("product/most-liked?page=$page");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    mostLikedProductList = productModel.products;
    popularProductNumber.value = productModel.count;
    // isLoading(false);

    return mostLikedProductList;
  }

  getProductDetails() async {
    isLoading(true);
    var response = await NetworkHandler.get("product/get?page=0");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    productList = productModel.products;
    productNumber.value = productModel.count;
    isLoading(false);
    return productList;
  }

  getMoreProducts(List<Product> list) async {
    count.value = count.value + 1;

    var response = await NetworkHandler.get("product/get?page=$count");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    list.addAll(productModel.products);
    length.value = list.length;
  }

  getProductsByCategory(String categoryId) async {
    var response =
        await NetworkHandler.get("product/product-by-category/$categoryId");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    productByCategoryList = productModel.products;
    return productByCategoryList;
  }

  final RxList<Product> _wishlist = RxList<Product>([]);
  RxBool isLiked = false.obs;
  List<Product> get wishlist => _wishlist;

  void addToWishlist(Product product) {
    product.liked = true;
    _wishlist.add(product);
    updateLikedStatus(product);
    // var response = NetworkHandler.post(
    //     {"productId": product.id}, "user/customer/add-liked-product");
  }

  void removeFromWishlist(Product product) {
    product.liked = false;
    _wishlist.remove(product);
    updateLikedStatus(product);
    // var response = NetworkHandler.delete(
    //     {"productId": product.id}, "user/customer/remove-liked-product");
  }

  void updateLikedStatus(Product product) {
    final index = productList.indexOf(product);
    if (index >= 0) {
      productList[index].liked = _wishlist.contains(product);
    }
  }

  getFiltredProducts(RangeValues rangeValue, double rating) async {
    isLoading(true);
    var response = await NetworkHandler.get(
        "product/filter?rating=$rating&min=${rangeValue.start}&max=${rangeValue.end}");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    print(productModel.products);
    filtredProductsList = productModel.products;
    isLoading(false);
    return productModel;
  }

  getDiscountedProducts(int discount) async {
    var response =
        await NetworkHandler.get("product/discount?discount=$discount");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    discountedProductsList = productModel.products;
    return discountedProductsList;
  }
}
