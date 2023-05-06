import 'package:ARkea/utils/colors.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../ViewModel/Address_controller.dart';
import '../widgets/app_bar.dart';
import '../widgets/form_textfiled.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressState();
}

AddressController addressController = Get.put(AddressController());

class _AddressState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Address'),
      body: SingleChildScrollView(
        child: Form(
          child: Column(
            children: [
              const SizedBox(height: 40),
              FormTextFiled(
                  label: 'City',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.city),
              const SizedBox(height: 20),
              FormTextFiled(
                  label: 'State',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.state),
              const SizedBox(height: 20),
              FormTextFiled(
                  label: 'Country',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.country),
              const SizedBox(height: 20),
              FormTextFiled(
                  label: 'Zip Code',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.zipCode),
              const SizedBox(height: 20),
              FormTextFiled(
                  label: 'line 1',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.line1),
              const SizedBox(height: 20),
              FormTextFiled(
                  label: 'line 1',
                  prefIcon: Icon(
                    LineAwesomeIcons.user,
                    color: MyColors.captionColor,
                  ),
                  controller: addressController.line2),
              const SizedBox(height: 20),
              SizedBox(
                width: gWidth / 2,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    addressController.Address();
                    Get.snackbar("Success", "your address has been saved");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.btnBorderColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
