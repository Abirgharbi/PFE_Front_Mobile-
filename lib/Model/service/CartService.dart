import 'dart:convert';

import 'package:arkea/Model/cart_model.dart';
import 'package:arkea/Model/product_card_model.dart';
import 'package:arkea/Model/product_model.dart';
import 'package:arkea/Model/service/CartService.dart';
import 'package:arkea/Model/service/network_handler.dart';
import 'package:arkea/ViewModel/product_controller.dart';
import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CartService {
  RxList<Cart> productCarts = <Cart>[].obs;
  RxDouble orderSum = 0.0.obs;
  double orderCost = 0.0;
  
  RxBool exist = false.obs; 
  late Cart foundProduct; 

  void addToCart(Product product) {
    Cart cart = Cart(product: product);
    if (product.quantity! > 0) {
      product.quantity = product.quantity! - 1;
      verifyProductExistence(cart);
      if (exist.isTrue) {
        final index = productCarts.indexOf(foundProduct);
        productCarts[index].quantity = productCarts[index].quantity + 1;
        exist.value = false;
      } else {
        productCarts.add(cart);
      }
      calculateTotal();
    } else {
      Get.snackbar("Error", "Product out of stock");
    }
  }

  void decreaseQuantity(Product product) {
    Cart cart = Cart(product: product);
    product.quantity = product.quantity! + 1;
    final index = productCarts.indexOf(foundProduct);
    productCarts[index].quantity -= 1;
    orderSum.value -= product.price;
    orderCost -= product.productCost!;
  }

  double calculateTotal() {
    orderSum.value = 0.0;
    orderCost = 0.0;
    for (var i = 0; i < productCarts.length; i++) {
      orderSum.value += productCarts[i].product.price * productCarts[i].quantity;
      orderCost += productCarts[i].product.productCost! * productCarts[i].quantity;
    }
    return orderSum.value;
  }

  void saveCart() {
    sharedPrefs.setStringList("cart", productCarts.map((e) => jsonEncode(e.toJson())).toList());
    sharedPrefs.setPref('orderSum', orderSum.value.toString());
  }

  void verifyProductExistence(Cart cart) {
    exist.value = false;
    for (var i = 0; i < productCarts.length; i++) {
      if (productCarts[i].product.id == cart.product.id) {
        exist.value = true;
        foundProduct = productCarts[i];  // Assigner le produit trouvé
        break;
      }
    }
  }
}
