import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import '../utils/shared_preferences.dart';

class ProductController extends GetxController {
  RxBool isLoading = false.obs;
  RxInt countPopular = 0.obs;
  RxInt count = 0.obs;
  RxInt countRecent = 0.obs;
  RxInt length = 5.obs;
  RxInt productNumber = 0.obs;
  RxInt popularProductNumber = 0.obs;
  RxInt recentProductNumber = 0.obs;

  List<Product> productList = [];
  List<Product> productByCategoryList = [];
  List<Product> mostLikedProductList = [];
  List<Product> recentProductsList = [];
  List<Product> filtredProductsList = [];
  List<Product> discountedProductsList = [];

  RxList<Product> wishlist = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    getRecentProducts();
    getProductDetails();
    getMostLikedProducts(0);
    loadWishlist();
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
    countPopular.value = countPopular.value + 1;
    var response = await NetworkHandler.get("product/popular?page=$page");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
    mostLikedProductList = productModel.products;
    popularProductNumber.value = productModel.count;

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

  void loadWishlist() {
    sharedPrefs.getStringList("wishlist").then((savedWishlist) {
      if (savedWishlist != null) {
        wishlist.addAll(
          savedWishlist.map((e) => Product.fromJson(json.decode(e))),
        );
        updateLikedStatus();
      }
    });
  }

  void addToWishlist(Product product) {
    product.liked = true;

    bool productExists = wishlist.any((p) => p.id == product.id);

    if (!productExists) {
      wishlist.add(product);
    }

    for (var p in productList) {
      if (p.id == product.id) {
        p.liked = true;
      }
    }

    productByCategoryList.forEach((p) {
      if (p.id == product.id) {
        p.liked = true;
      }
    });

    mostLikedProductList.forEach((p) {
      if (p.id == product.id) {
        p.liked = true;
      }
    });

    recentProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = true;
      }
    });

    filtredProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = true;
      }
    });

    discountedProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = true;
      }
    });

    sharedPrefs.setStringList(
      "wishlist",
      wishlist.map((e) => jsonEncode(e.toJson())).toList(),
    );

    updateLikedStatus();
  }

  void removeFromWishlist(Product product) {
    product.liked = false;

    final removedProduct = wishlist.firstWhere(
      (p) => p.id == product.id,
    );
    if (removedProduct != null) {
      wishlist.remove(removedProduct);
    }

    productList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    productByCategoryList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    mostLikedProductList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    recentProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    filtredProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    discountedProductsList.forEach((p) {
      if (p.id == product.id) {
        p.liked = false;
      }
    });

    sharedPrefs.setStringList(
      "wishlist",
      wishlist.map((e) => jsonEncode(e.toJson())).toList(),
    );

    updateLikedStatus();
  }

  void updateLikedStatus() {
    productList.forEach((product) {
      product.liked = wishlist.contains(product);
    });
  }

  getFiltredProducts(RangeValues rangeValue, double rating) async {
    isLoading(true);
    var response = await NetworkHandler.get(
        "product/filter?rating=$rating&min=${rangeValue.start}&max=${rangeValue.end}");
    ProductModel productModel = ProductModel.fromJson(json.decode(response));
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
