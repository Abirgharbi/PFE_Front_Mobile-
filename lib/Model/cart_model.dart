import 'product_model.dart';

import 'dart:convert';

Cart cartFromJson(String str) => Cart.fromJson(json.decode(str));

String cartToJson(Cart data) => json.encode(data.toJson());

class Cart {
  final Product product;
  int quantity;

  Cart({required this.product, this.quantity = 1});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        product: Product.fromJson(json["product"]),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "product": product.toJson(),
        "quantity": quantity,
      };
}
