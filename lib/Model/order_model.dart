import 'package:get/get.dart';

import 'cart_model.dart';
import 'product_model.dart';

class Order {
  final List<Cart> orderList;
  num orderSum;

  Order({required this.orderList, required this.orderSum});
}
