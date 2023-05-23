import 'dart:convert';
import 'dart:io';
import 'package:ARkea/utils/shared_preferences.dart';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../Model/customer_model.dart';
import '../Model/service/network_handler.dart';
import '../Views/screens/profil_page/profil_page.dart';

class ProfileController extends GetxController {
  final TextEditingController name = TextEditingController();
  final TextEditingController phoneNumber = TextEditingController();

  @override
  void onInit() async {
    // TODO: implement onInit

    super.onInit();
    name.text = await sharedPrefs.getPref('customerName');
    phoneNumber.text = await sharedPrefs.getPref('customerPhoneNumber');
  }

  void updateProfile(String? imageUrl) async {
    final customerEmail = (await sharedPrefs.getPref('customerEmail'));
    CustomerModel customerModel = CustomerModel(
        name: name.text,
        email: customerEmail,
        image: imageUrl,
        phone: phoneNumber.text);
    print(customerModel);

    final id = (await sharedPrefs.getPref('customerId'));

    print(id);

    var response = NetworkHandler.put(
        customerModelToJson(customerModel), "user/customer/update/$id");
    sharedPrefs.setPref('customerName', name.text);
    sharedPrefs.setPref('customerImage', imageUrl!);
    sharedPrefs.setPref('customerPhoneNumber', phoneNumber.text);
    //var data = json.decode(response);
    // Get.to(() => ProfileScreen());
  }
}
