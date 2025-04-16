import 'dart:convert';
import '../Model/product_model.dart';
import '../Model/service/network_handler.dart';
import 'package:flutter/material.dart';

class ProductService {
  Future<ProductModel> getProducts({int page = 0}) async {
    var response = await NetworkHandler.get("product/get?page=$page");
    return ProductModel.fromJson(json.decode(response));
  }

  Future<ProductModel> getRecentProducts({int page = 0}) async {
    var response = await NetworkHandler.get("product/recent?page=$page");
    return ProductModel.fromJson(json.decode(response));
  }

  Future<ProductModel> getPopularProducts({int page = 0}) async {
    var response = await NetworkHandler.get("product/popular?page=$page");
    return ProductModel.fromJson(json.decode(response));
  }

  Future<ProductModel> getByCategory(String categoryId) async {
    var response = await NetworkHandler.get(
      "product/product-by-category/$categoryId",
    );
    return ProductModel.fromJson(json.decode(response));
  }

  Future<ProductModel> getFilteredProducts(
    RangeValues rangeValue,
    double rating,
  ) async {
    var response = await NetworkHandler.get(
      "product/filter?rating=$rating&min=${rangeValue.start}&max=${rangeValue.end}",
    );
    return ProductModel.fromJson(json.decode(response));
  }

  Future<ProductModel> getDiscountedProducts(int discount) async {
    var response = await NetworkHandler.get(
      "product/discount?discount=$discount",
    );
    return ProductModel.fromJson(json.decode(response));
  }
}
