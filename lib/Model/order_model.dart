import 'dart:convert';

import 'product_card_model.dart';

OrderModel orderModelFromJson(String str) =>
    OrderModel.fromJson(json.decode(str));

String orderModelToJson(OrderModel data) => json.encode(data.toJson());

class OrderModel {
  OrderModel({
    this.orders,
  });

  List<Order>? orders;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    List<Order> orders = [];
    if (json["orders"] != null) {
      orders = List<Order>.from(json["orders"].map((x) => Order.fromJson(x)));
    }
    return OrderModel(
      orders: orders,
    );
  }

  Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders!.map((x) => x.toJson())),
      };
}

class Order {
  String? shippingStatus;
  double? amount;
  String? addressId;
  String? customerId;
  double? revenue;
  List<ProductCard>? productCard;
  DateTime? createdAt;

  Order({
    this.shippingStatus,
    this.amount,
    this.addressId,
    this.customerId,
    this.revenue,
    this.productCard,
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) => Order(
        shippingStatus: json["shippingStatus"],
        amount: json["amount"].toDouble(),
        addressId: json["adressId"],
        customerId: json["customerId"],
        revenue: json["revenue"].toDouble(),
        productCard: List<ProductCard>.from(
            json["productCard"].map((x) => ProductCard.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "shippingStatus": shippingStatus,
        "amount": amount,
        "addressId": addressId,
        "customerId": customerId,
        "revenue": revenue,
        "productCard": List<dynamic>.from(productCard!.map((x) => x.toJson())),
        "createdAt": createdAt,
      };
}
