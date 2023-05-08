import 'dart:convert';

import 'package:ARkea/Model/cart_model.dart';
import 'package:ARkea/Model/product_model.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/service/network_handler.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  final RxList<Cart> demoCarts = RxList<Cart>([]);
  RxBool exist = false.obs;
  late Cart foundProduct;
  RxDouble orderSum = 0.0.obs;
  RxBool isAdded = false.obs;

  RxInt productNbInCart = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getOrderSum();
  }

  void addToCart(Product product) {
    Cart cart = Cart(product: product);
    if (product.quantity! > 0) {
      product.quantity = product.quantity! - 1;
    } else {
      Get.snackbar("Error", "Product out of stock");
    }
    verifyProductExistence(cart);
    if (exist.isTrue) {
      final index = demoCarts.indexOf(foundProduct);

      demoCarts[index].quantity = demoCarts[index].quantity + 1;
    } else {
      demoCarts.add(cart);
      productNbInCart.value = demoCarts.length;
    }

    for (var i = 0; i < demoCarts.length; i++) {
      orderSum.value = demoCarts[i].product.price * demoCarts[i].quantity;
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);
    product.quantity = product.quantity! + 1;

    final index = demoCarts.indexOf(foundProduct);
    demoCarts[index].quantity = demoCarts[index].quantity - 1;

    orderSum.value = orderSum.value - product.price;
  }

  void verifyProductExistence(Cart cart) {
    int i = 0;

    if (demoCarts.isNotEmpty) {
      do {
        if (demoCarts.elementAt(i).product.id == cart.product.id) {
          exist.value = true;
          foundProduct = demoCarts.elementAt(i);
        }
        i++;
      } while (i < demoCarts.length && exist.isFalse);
    }
  }

  checkAvailability() async {
    Map<String, int> products = <String, int>{};
    for (var i = 0; i < demoCarts.length; i++) {
      products
          .addAll({demoCarts[i].product.id.toString(): demoCarts[i].quantity});
    }
    print(products);
    var response =
        await NetworkHandler.post(products, "product/check-availability");
    ProductModel productModel = ProductModel.fromJson(jsonDecode(response));
    List<Product> productsUnAvailable = productModel.products;
    for (var i = 0; i < productsUnAvailable.length; i++) {
      if (productsUnAvailable[i].quantity == 0) {
        Get.snackbar("Error", "${productsUnAvailable[i].name} out of stock");
      }
    }
  }
}
