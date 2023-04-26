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
  Review({
    required this.rating,
    required this.comment,
    required this.customerId,
    this.productId,
    this.createdAt,
  });

  String rating;
  int comment;
  String customerId;
  String? productId;
  DateTime? createdAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        rating: json["rating"],
        comment: json["comment"],
        customerId: json["customerId"],
        productId: json["productId"],
        createdAt: json["compare_at_price"],
      );

  Map<String, dynamic> toJson() => {
        "rating": rating,
        "comment": comment,
        "customerId": customerId,
        "productId": productId,
        "createdAt": createdAt,
      };
}
