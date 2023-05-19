import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ViewModel/signup_controller.dart';
import '../../utils/colors.dart';
import '../../utils/sizes.dart';

class FormTextFiled extends StatefulWidget {
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
  State<FormTextFiled> createState() => _FormTextFiledState();
}

class _FormTextFiledState extends State<FormTextFiled> {
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
                enabled: widget.enabled,
                initialValue: widget.initialValue,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                controller: widget.controller,
                keyboardType: widget.typeInput,
                style: const TextStyle(color: Colors.black54, fontSize: 15),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: widget.hintText,
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
                  prefixIcon: widget.prefIcon,
                  suffixIcon: widget.sufIcon,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
                  labelText: widget.label,
                  labelStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                      fontWeight: FontWeight.w400),
                ),
                validator: widget.validator),
          ),
        ],
      ),
    );
  }
}
