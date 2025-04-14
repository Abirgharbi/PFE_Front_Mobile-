import 'package:flutter/material.dart';

import '../../Model/service/network_handler.dart';
import '../../utils/sizes.dart';
import 'package:arkea/utils/shared_preferences.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    final image = sharedPrefs.getPref('customerImage') as String;
    // image.length > 0 ? Image(image: image) : 'default image path here';
    return Scaffold(
        body: SafeArea(
            child: Container(
      width: (gWidth / 5) * 4,
      height: double.infinity,
      color: Colors.black,
      child: SafeArea(
        child: Column(children: [
          Image(
            image: AssetImage(image),
            height: 100,
          ),
        ]),
      ),
    )));
  }
}
