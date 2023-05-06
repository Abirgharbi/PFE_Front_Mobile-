import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) => json.encode(data.toJson());

class AddressModel {
  String? city;
  String? country;
  String? state;
  int? zipCode;
  String? line1;
  String? line2;
  String? customerEmail;
  AddressModel(
      {this.city,
      this.country,
      this.state,
      this.zipCode,
      this.line1,
      this.line2,
      this.customerEmail});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
        city: json["city"],
        country: json["country"],
        state: json["state"],
        zipCode: json["zipCode"],
        line1: json["line1"],
        line2: json["line2"],
        customerEmail: json["customerEmail"],
      );

  Map<String, dynamic> toJson() => {
        "city": city,
        "country": country,
        "state": state,
        "zipCode": zipCode,
        "line1": line1,
        "line2": line2,
        "customerEmail": customerEmail,
      };
}
