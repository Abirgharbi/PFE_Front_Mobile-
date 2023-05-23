import 'package:ARkea/utils/colors.dart';
import 'package:ARkea/utils/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:ARkea/utils/shared_preferences.dart';

import '../../../Model/service/network_handler.dart';
import '../../../ViewModel/Address_controller.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/form_textfiled.dart';

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
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'city'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: "City",
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.city),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20,
              ),
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'state'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: 'State',
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.state),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'country'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: 'Country',
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.country),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'zipCode'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: 'Zip Code',
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.zipCode),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'line1'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: 'line 1',
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.line1),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<String>(
                future: sharedPrefs.getPref(
                    'line2'), // a previously-obtained Future<String> or null
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  List<Widget> children;
                  if (snapshot.hasData) {
                    children = <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: FormTextFiled(
                            label: 'line 2',
                            prefIcon: Icon(
                              LineAwesomeIcons.map_marker,
                              color: MyColors.captionColor,
                            ),
                            controller: addressController.line2),
                      ),
                    ];
                  } else if (snapshot.hasError) {
                    children = <Widget>[Text('${snapshot.error}')];
                  } else {
                    children = const <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: CircularProgressIndicator(),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: Text('Awaiting result...'),
                      ),
                    ];
                  }
                  return Center(
                    child: Column(
                      children: children,
                    ),
                  );
                },
              ),
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
