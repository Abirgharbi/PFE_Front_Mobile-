import 'package:get/get.dart';

import 'product_model.dart';

class Cart {
  final Product product;
  int quantity;
  double price = 0;
  Cart({required this.product, this.quantity = 1});

  Map<String, dynamic> toJson() {
    return {
      'product': product,
      'quantity': quantity,
      'price': price,
    };
  }
}
