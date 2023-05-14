import 'dart:convert';

ProductCardModel productCardModelFromJson(String str) =>
    ProductCardModel.fromJson(json.decode(str));

String productCardModelToJson(ProductCardModel data) =>
    json.encode(data.toJson());

class ProductCardModel {
  ProductCardModel({
    required this.products,
  });

  List<ProductCard> products;

  factory ProductCardModel.fromJson(Map<String, dynamic> json) {
    List<ProductCard> products = [];
    if (json["products"] != null) {
      products = List<ProductCard>.from(
          json["products"].map((x) => ProductCard.fromJson(x)));
    }
    return ProductCardModel(
      products: products,
    );
  }

  Map<String, dynamic> toJson() => {
        "products": List<dynamic>.from(products.map((x) => x.toJson())),
      };
}

class ProductCard {
  String id;
  String name;
  double price;
  int quantity;

  ProductCard({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory ProductCard.fromJson(Map<String, dynamic> json) => ProductCard(
        id: json["_id"],
        name: json["name"],
        price: json["price"].toDouble(),
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "price": price,
        "quantity": quantity,
      };
}
