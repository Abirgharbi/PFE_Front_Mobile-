import 'dart:convert';

CustomerModel customerModelFromJson(String str) =>
    CustomerModel.fromJson(json.decode(str));

String customerModelToJson(CustomerModel data) => json.encode(data.toJson());

class CustomerModel {
  CustomerModel({this.email, this.name, this.image});

  String? email;
  String? name;
  String? image;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
        email: json["email"],
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() =>
      {"email": email, "name": name, "image": image};
}
