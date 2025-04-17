import 'dart:convert';

import 'package:arkea/Model/cart_model.dart';
import 'package:arkea/Model/order_model.dart';
import 'package:arkea/Model/product_card_model.dart';
import 'package:arkea/Model/product_model.dart';
import 'package:arkea/Model/service/CartService.dart';
import 'package:arkea/Model/service/network_handler.dart';
import 'package:arkea/ViewModel/product_controller.dart';
import 'package:arkea/utils/colors.dart';
import 'package:arkea/utils/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderService {
  
  Future<void> addOrder(CartService cartService) async {
    final customerId = await sharedPrefs.getPref("customerId");
    final addressId = await sharedPrefs.getPref("addressId");

    List<ProductCard> cards = cartService.productCarts.map((cart) => ProductCard(
      id: cart.product.id,
      quantity: cart.quantity,
      price: cart.product.price,
      name: cart.product.name,
    )).toList();

    Order order = Order()
      ..productCard = cards
      ..amount = cartService.orderSum.value
      ..revenue = cartService.orderSum.value - cartService.orderCost
      ..addressId = addressId
      ..customerId = customerId;

    await NetworkHandler.post(order, "order/add");
    await NetworkHandler.put(json.encode({'spend': cartService.orderSum.value}), "user/customer/spending/$customerId");
    cartService.productCarts.clear();
    cartService.orderSum.value = 0.0;
    sharedPrefs.removePref("cart");
  }

  Future<List<Order>> fetchOrders(String id) async {
    var response = await NetworkHandler.get("order/getCustomerOrders/$id");
    return List.from(jsonDecode(response)).map((e) => Order.fromJson(e)).toList();
  }
}
