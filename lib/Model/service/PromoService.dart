import 'dart:convert';

import 'package:arkea/Model/cart_model.dart';
import 'package:arkea/Model/product_card_model.dart';
import 'package:arkea/Model/product_model.dart';
import 'package:arkea/Model/promo_model.dart';
import 'package:arkea/Model/service/CartService.dart';
import 'package:arkea/Model/service/network_handler.dart';
import 'package:arkea/ViewModel/product_controller.dart';
import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class PromoService {
  
  TextEditingController promoCode = TextEditingController();
  RxString message = ''.obs;
  RxBool applyDisabled = false.obs;

  void applyPromo(CartService cartService) async {
    final promos = await fetchPromos();
    final match = promos.firstWhereOrNull((p) => p.code == promoCode.text);
    if (match != null) {
      double discount = match.discount.toDouble();
      cartService.orderSum.value *= (1 - discount / 100);
      applyDisabled.value = true;
      message.value = "promotion applied";
    } else {
      message.value = "Invalid promo code";
    }
  }

  Future<List<Promo>> fetchPromos() async {
    var response = await NetworkHandler.get("order/promo/getValidPromos");
    return PromoModel.fromJson(json.decode(response)).promos;
  }
}
