import 'dart:convert';
import 'dart:io';

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
    name.text = await NetworkHandler.getItem('customerName');
    phoneNumber.text = await NetworkHandler.getItem('customerPhoneNumber');
  }

  void updateProfile(String? imageUrl) async {
    final customerEmail = (await NetworkHandler.getItem('customerEmail'));
    CustomerModel customerModel = CustomerModel(
        name: name.text,
        email: customerEmail,
        image: imageUrl,
        phone: phoneNumber.text);
    print(customerModel);

    final id = (await NetworkHandler.getItem('customerId'));

    print(id);

    var response = NetworkHandler.put(
        customerModelToJson(customerModel), "user/customer/update/$id");
    NetworkHandler.storeCustomer('customerName', name.text);
    NetworkHandler.storeCustomer('customerImage', imageUrl!);
    NetworkHandler.storeCustomer('customerPhoneNumber', phoneNumber.text);
    //var data = json.decode(response);
    // Get.to(() => ProfileScreen());
  }
}
