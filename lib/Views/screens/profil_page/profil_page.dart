import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:ARkea/Views/screens/profil_page/noLoggedIn_profilPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../Model/service/network_handler.dart';
import '../../../ViewModel/login_controller.dart';

import '../../../ViewModel/signup_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import './edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});
  final loginController = Get.put(LoginController());
  final signupController = Get.put(SignupScreenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Profile",
          style: Theme.of(context).textTheme.displayMedium,
        ),
      ),
      body: Obx(
        () => loginController.isLogged.value == false &&
                signupController.isSigned.value == false
            ? const noLoggedIn_profilPage()
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(tDefaultSize),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          FutureBuilder<String>(
                            future: NetworkHandler.getItem(
                                'customerImage'), 
                            builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) {
                              List<Widget> children;
                              if (snapshot.hasData) {
                                children = <Widget>[
                                  SizedBox(
                                    height: 120,
                                    width: 120,
                                    child: ClipOval(
                                      child: SizedBox.fromSize(
                                        size: const Size.fromRadius(
                                            100), // Image radius
                                        child: Image.network(
                                          '${snapshot.data}',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
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
                        ],
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      FutureBuilder<String>(
                        future: NetworkHandler.getItem(
                            'customerName'), // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 16),
                                child: Text(
                                  '${snapshot.data}',
                                  style:
                                      Theme.of(context).textTheme.displayMedium,
                                ),
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

                      FutureBuilder<String>(
                        future: NetworkHandler.getItem(
                            'customerEmail'), // a previously-obtained Future<String> or null
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          List<Widget> children;
                          if (snapshot.hasData) {
                            children = <Widget>[
                              Text(
                                '${snapshot.data}',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
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
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        height: 45,
                        child: ElevatedButton(
                          onPressed: () {
                            Get.to(() => EditProfileScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.btnColor,
                            side: BorderSide.none,
                            shape: const StadiumBorder(),
                          ),
                          child: const Text(
                            "Edit Profile",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),

                      const SizedBox(
                        height: 60,
                      ),

                      ///Menu
                      ProfileMenuWidget(
                        title: "My orders",
                        icon: LineAwesomeIcons.dolly,
                        onPress: () {},
                      ),

                      ProfileMenuWidget(
                        title: "Address",
                        icon: LineAwesomeIcons.map_marker,
                        onPress: () {
                          Get.toNamed('/address');
                        },
                      ),

                      ProfileMenuWidget(
                        title: "Help Center",
                        icon: LineAwesomeIcons.headset,
                        onPress: () {},
                      ),
                      const Divider(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileMenuWidget(
                        title: "About Us",
                        icon: LineAwesomeIcons.info_circle,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Rate Us",
                        icon: LineAwesomeIcons.star,
                        onPress: () {},
                      ),
                      ProfileMenuWidget(
                        title: "Logout ",
                        textColor: Colors.red,
                        endIcon: false,
                        icon: LineAwesomeIcons.alternate_sign_out,
                        onPress: () {
                          loginController.logOut();
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget(
      {super.key,
      required this.title,
      this.endIcon = true,
      required this.icon,
      required this.onPress,
      this.textColor});

  final String title;
  final IconData icon;
  final VoidCallback onPress;
  final bool endIcon;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onPress,
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: MyColors.btnBorderColor.withOpacity(0.1)),
          child: Icon(
            icon,
            color: MyColors.btnColor,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineMedium
              ?.apply(color: textColor),
        ),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Colors.grey.withOpacity(0.1)),
                child: const Icon(
                  LineAwesomeIcons.angle_right,
                  size: 18.0,
                  color: Colors.grey,
                ),
              )
            : null);
  }
}
