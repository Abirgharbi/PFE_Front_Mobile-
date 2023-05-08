// To parse this JSON data, do
//
//     final promoModel = promoModelFromJson(jsonString);

import 'dart:convert';

PromoModel promoModelFromJson(String str) =>
    PromoModel.fromJson(json.decode(str));

String promoModelToJson(PromoModel data) => json.encode(data.toJson());

class PromoModel {
  List<Promo> promos;

  PromoModel({
    required this.promos,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => PromoModel(
        promos: List<Promo>.from(json["promos"].map((x) => Promo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "promos": List<dynamic>.from(promos.map((x) => x.toJson())),
      };
}

class Promo {
  String id;
  String code;
  DateTime startDate;
  DateTime expireDate;
  int discount;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  Promo({
    required this.id,
    required this.code,
    required this.startDate,
    required this.expireDate,
    required this.discount,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory Promo.fromJson(Map<String, dynamic> json) => Promo(
        id: json["_id"],
        code: json["code"],
        startDate: DateTime.parse(json["start_date"]),
        expireDate: DateTime.parse(json["expire_date"]),
        discount: json["discount"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "start_date":
            "${startDate.year.toString().padLeft(4, '0')}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}",
        "expire_date":
            "${expireDate.year.toString().padLeft(4, '0')}-${expireDate.month.toString().padLeft(2, '0')}-${expireDate.day.toString().padLeft(2, '0')}",
        "discount": discount,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
