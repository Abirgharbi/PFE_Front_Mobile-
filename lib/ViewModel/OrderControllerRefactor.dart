// import 'dart:convert';

// import 'package:arkea/Model/cart_model.dart';
// import 'package:arkea/Model/product_card_model.dart';
// import 'package:arkea/Model/product_model.dart';
// import 'package:arkea/Model/service/AvailabilityService.dart';
// import 'package:arkea/Model/service/CartService.dart';
// import 'package:arkea/Model/service/OrderService.dart';
// import 'package:arkea/Model/service/PromoService.dart';
// import 'package:arkea/ViewModel/product_controller.dart';
// import 'package:arkea/utils/colors.dart';
// import 'package:arkea/utils/shared_preferences.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import '../Model/order_model.dart';
// import '../Model/promo_model.dart';
// import '../Model/service/network_handler.dart';

// class OrderController extends GetxController {
  
//   final cartService = CartService();
//   final promoService = PromoService();
//   final orderService = OrderService();
//   final availabilityService = AvailabilityService();

//   void addProduct(product) => cartService.addToCart(product);
//   void decreaseProduct(product) => cartService.decreaseQuantity(product);
//   void applyPromo() => promoService.applyPromo(cartService);
//   void checkAvailability() => availabilityService.checkAvailability(cartService);
//   void createOrder() => orderService.addOrder(cartService);
//   Future<List<Order>> fetchOrders(String id) => orderService.fetchOrders(id);
// }
