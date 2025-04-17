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


class AvailabilityService {
  
  void checkAvailability(CartService cartService) async {
    Map<String, int> products = {
      for (var item in cartService.productCarts)
        item.product.id.toString(): item.quantity
    };

    var response = await NetworkHandler.post(
      jsonEncode(products), "product/check-availability");

    List<Product> unavailable =
      ProductModel.fromJson(jsonDecode(response)).products;

    for (var p in unavailable) {
      showDialogFor(p, cartService);
    }
  }

  void showDialogFor(Product product, CartService cartService) {
    Get.defaultDialog(
      title: 'Stock limité',
      content: Text("Il reste seulement ${product.quantity} de ${product.name}"),
      onConfirm: () {
        cartService.productCarts
            .removeWhere((e) => e.product.id == product.id);
        cartService.saveCart();
      },
      onCancel: () {},
      textConfirm: 'OK',
      textCancel: 'Annuler',
    );
  }
}
