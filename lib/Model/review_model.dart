import 'dart:convert';

ReviewModel reviewModelFromJson(String str) =>
    ReviewModel.fromJson(json.decode(str));

String reviewModelToJson(ReviewModel data) => json.encode(data.toJson());

class ReviewModel {
  ReviewModel({
    required this.count,
    required this.reviews,
  });

  int count;
  List<Review> reviews;

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    List<Review> reviews = [];
    if (json["reviews"] != null) {
      reviews =
          List<Review>.from(json["reviews"].map((x) => Review.fromJson(x)));
    }
    return ReviewModel(
      count: json["count"],
      reviews: reviews,
    );
  }

  Map<String, dynamic> toJson() => {
        "count": count,
        "reviews": List<dynamic>.from(reviews.map((x) => x.toJson())),
      };
}

class Review {
  double rating;
  String comment;
  String customerImage;
  String customerName;
  String? productId;
  DateTime? createdAt;

  Review({
    required this.rating,
    required this.comment,
    required this.customerName,
    required this.customerImage,
    this.productId,
    this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"].toDouble(),
        comment: json["comment"],
        customerName: json["customerName"],
        customerImage: json["customerImage"],
        productId: json["productId"],
        createdAt: json["compare_at_price"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "customerName": customerName,
        "customerImage": customerImage,
        "productId": productId,
        "createdAt": createdAt,
      };
}
