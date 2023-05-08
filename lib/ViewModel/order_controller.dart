import 'dart:convert';

import 'package:ARkea/Model/cart_model.dart';
import 'package:ARkea/Model/product_model.dart';
import 'package:ARkea/ViewModel/product_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Model/promo_model.dart';
import '../Model/service/network_handler.dart';

var productController = Get.put(ProductController());

class OrderController extends GetxController {
  TextEditingController promoCode = TextEditingController();
  final RxList<Cart> demoCarts = RxList<Cart>([]);
  RxBool exist = false.obs;
  RxBool applyDisabled = false.obs;
  late Cart foundProduct;
  late Promo validPromo;
  RxDouble orderSum = 0.0.obs;
  RxString message = "".obs;
  RxBool isAdded = false.obs;
  RxBool isValidCode = false.obs;
  List<Promo> validPromoList = [];

  RxInt productNbInCart = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // getOrderSum();
  }

  void addToCart(Product product) {
    // print(product.quantity);
    Cart cart = Cart(product: product);

    print(demoCarts);
    verifyProductExistence(cart);
    if (exist.isTrue) {
      final index = demoCarts.indexOf(foundProduct);
      demoCarts[index].quantity = demoCarts[index].quantity + 1;

      print("exists");
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

    final index = demoCarts.indexOf(foundProduct);
    demoCarts[index].quantity = demoCarts[index].quantity - 1;

    orderSum.value = orderSum.value - product.price;
  }

  void verifyProductExistence(Cart cart) {
    int i = 0;

    if (demoCarts.length != 0) {
      do {
        if (demoCarts.elementAt(i).product == cart.product) {
          exist.value = true;
          foundProduct = demoCarts.elementAt(i);
        }
        i++;
      } while (i < demoCarts.length && exist.isFalse);
    }
  }

  void applyPromoCode() async {
    int i = 0;
    var response = await NetworkHandler.get("order/promo/getValidPromos");

    try {
      //var data = await json.decode(json.encode(response));
      //promoList = json.decode(json.encode(response));

      PromoModel promoModel = PromoModel.fromJson(json.decode(response));

      print(promoModel.promos.elementAt(0).code);
      validPromoList = promoModel.promos;

      if (validPromoList.length != 0) {
        do {
          if (validPromoList.elementAt(i).code == promoCode.text) {
            isValidCode.value = true;
            validPromo = validPromoList.elementAt(i);
          }
          i++;
        } while (i < validPromoList.length && isValidCode.isFalse);
      }

      if (isValidCode == true) {
        orderSum.value = orderSum.value * (validPromo.discount / 100);
        applyDisabled.value = true;
        message.value = "";
      } else {
        message.value = "Invalid promo code";
      }
    } catch (e) {
      print(e);
    }
  }
}
