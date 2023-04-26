import 'package:get/get.dart';

import 'product_model.dart';

class Cart {
  final Product product;
  final int? quantity;

  Cart({required this.product, this.quantity});
}
