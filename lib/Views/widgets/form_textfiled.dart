import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ViewModel/signup_controller.dart';
import '../../utils/colors.dart';
import '../../utils/sizes.dart';

class FormTextFiled extends StatelessWidget {
  final Widget? sufIcon;
  final Widget? prefIcon;
  final TextInputType? typeInput;
  final String? label;
  final TextEditingController? controller;
  final String? initialValue;
  final bool? enabled;
  final String? hintText;
  final String? Function(String?)? validator;

  const FormTextFiled(
      {super.key,
      this.sufIcon,
      this.label,
      this.prefIcon,
      this.typeInput,
      this.controller,
      this.initialValue,
      this.enabled,
      this.hintText,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            //height: 50,
            width: gWidth / 1.3,
            child: TextFormField(
                enabled: enabled,
                initialValue: initialValue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: controller,
                keyboardType: typeInput,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: hintText,
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: MyColors.btnBorderColor),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 2),
                  ),
                  prefixIcon: prefIcon,
                  suffixIcon: sufIcon,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  labelText: label,
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                validator: validator),
          ),
        ],
      ),
    );
  }
}
