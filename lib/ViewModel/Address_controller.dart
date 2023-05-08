import 'dart:convert';

import 'package:ARkea/Model/Address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/service/network_handler.dart';

class AddressController extends GetxController {
  final TextEditingController city = TextEditingController();
  final TextEditingController country = TextEditingController();
  final TextEditingController state = TextEditingController();
  final TextEditingController zipCode = TextEditingController();
  final TextEditingController line1 = TextEditingController();
  final TextEditingController line2 = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    city.text = await NetworkHandler.getItem('city');
    country.text = await NetworkHandler.getItem('country');
    state.text = await NetworkHandler.getItem('state');
    zipCode.text = await NetworkHandler.getItem('zipCode');
    line1.text = await NetworkHandler.getItem('line1');
    line2.text = await NetworkHandler.getItem('line2');
  }

  // add address
  void Address() async {
    var email = await NetworkHandler.getItem('customerEmail');
    AddressModel addressModel = AddressModel(
      city: city.text,
      country: country.text,
      state: state.text,
      zipCode: int.parse(zipCode.text),
      line1: line1.text,
      line2: line2.text,
      customerEmail: email,
    );

    String address = "${line1.text}, ${city.text}, ${country.text}";
    NetworkHandler.storeCustomer('address', address);

    print(addressModelToJson(addressModel));
    var response = await NetworkHandler.post(
        addressModelToJson(addressModel), "user/customer/address");
    // var data = json.decode(response);
    print(response);
  }
}
