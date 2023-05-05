import 'dart:convert';

import 'package:flutter/material.dart';

import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import 'package:get/get.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt count = 0.obs;
  RxInt length = 5.obs;
  RxInt productNumber = 0.obs;

  var product = 0.obs;

  List<Product> productList = [];
  List<Product> productByCategoryList = [];
  List<Product> mostLikedProductList = [];
  List<Product> recentProductsList = [];
  List<Product> filtredProductsList = [];

  @override
  void onInit() {
    super.onInit();
    getRecentProducts();
    getProductDetails();
    getMostLikedProducts();
  }

  getRecentProducts() async {
    isLoading(true);
    var response = await NetworkHandler.get("product/recent?page=0");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    recentProductsList = productModel.products;
    productNumber.value = productModel.count;
    isLoading(false);

    return recentProductsList;
  }

  getMoreRecentProducts(List<Product> list) async {
    count.value = count.value + 1;

    var response = await NetworkHandler.get("product/recent?page=$count");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    list.addAll(productModel.products);
    length.value = list.length;
  }

  getMostLikedProducts() async {
    isLoading(true);
    var response = await NetworkHandler.get("product/most-liked?page=0");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    mostLikedProductList = productModel.products;
    productNumber.value = productModel.count;
    isLoading(false);

    return mostLikedProductList;
  }

  getMoreMostLikedProducts(List<Product> list) async {
    count.value = count.value + 1;

    var response = await NetworkHandler.get("product/most-liked?page=$count");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    list.addAll(productModel.products);
    length.value = list.length;
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
    isLoading(true);
    var response =
        await NetworkHandler.get("product/product-by-category/$categoryId");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    count = productModel.count.obs;
    isLoading(false);
    return productModel;
  }

  final RxList<Product> _wishlist = RxList<Product>([]);
  RxBool isLiked = false.obs;
  List<Product> get wishlist => _wishlist;

  void addToWishlist(Product product) {
    product.liked = true;
    _wishlist.add(product);
    updateLikedStatus(product);
  }

  void removeFromWishlist(Product product) {
    product.liked = false;
    _wishlist.remove(product);
    updateLikedStatus(product);
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
}
