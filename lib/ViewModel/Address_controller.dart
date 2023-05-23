import 'dart:convert';
import 'package:ARkea/utils/shared_preferences.dart';

import 'package:ARkea/Model/Address_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    super.onInit();
    city.text = prefs.getString('city')!;
    country.text = prefs.getString('country')!;
    state.text = prefs.getString('state')!;
    zipCode.text = prefs.getString('zipCode')!;
    line1.text = prefs.getString('line1')!;
    line2.text = prefs.getString('line2')!;

    Address();
  }

  // add address
  void Address() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? email = prefs.getString('customerEmail');

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
    sharedPrefs.setPref('address', address);

    var response = await NetworkHandler.post(
        addressModelToJson(addressModel), "user/customer/address");
    addressModel = AddressModel.fromJson(json.decode(response));
    sharedPrefs.setPref('addressId', addressModel.id!);
  }
}
