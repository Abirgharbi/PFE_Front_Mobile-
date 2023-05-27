import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ViewModel/login_controller.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/form_textfiled.dart';
import '../../widgets/media_tile.dart';
import '../../widgets/sp_solid_button.dart';
import 'signup.dart';

var loginController = Get.put(LoginController());

bool isEnabled = false;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  String? validateValue(String? value) {
    if (value == null || value.isEmpty) {
      isEnabled = false;
      return "Field could not be Empty";
    } else if (!GetUtils.isEmail(value)) {
      isEnabled = false;
      return "Please Enter a Valid Email";
    } else {
      isEnabled = true;
      return null;
    }
  }

  LoginController loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
          ),
          resizeToAvoidBottomInset: true,
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const TopImage(),
                      const LoginText(),
                      const SizedBox(height: 15),
                      FadeInDown(
                        delay: const Duration(milliseconds: 1800),
                        child: FormTextFiled(
                            validator: (value) => validateValue(value),
                            controller: loginController.emailEditingController,
                            typeInput: TextInputType.emailAddress,
                            prefIcon: Icon(
                              Icons.email_outlined,
                              color: MyColors.captionColor,
                            ),
                            sufIcon: null,
                            label: "Email"),
                      ),
                      const SizedBox(height: 25),
                      FadeInDown(
                          delay: const Duration(milliseconds: 1400),
                          child: Container(
                            margin: const EdgeInsets.all(15),
                            width: gWidth / 2,
                            height: gHeight / 12,
                            child: Obx(
                              () {
                                return ElevatedButton(
                                  style: isEnabled == true
                                      ? ElevatedButton.styleFrom(
                                          fixedSize: const Size(50, 50),
                                          backgroundColor: MyColors.btnColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        )
                                      : ElevatedButton.styleFrom(
                                          fixedSize: const Size(50, 50),
                                          backgroundColor: MyColors.btnColor
                                              .withOpacity(0.7),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                  onPressed: isEnabled == true
                                      ? () async {
                                          await loginController.login();
                                        }
                                      : null,
                                  child: loginController.isLogginIn.value
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Text(
                                          "LogIn",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                );
                              },
                            ),
                          )),
                      const OrText(),
                      const SizedBox(
                        height: 10,
                      ),
                      FadeInDown(
                        delay: const Duration(milliseconds: 600),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              MediaTile(
                                imagePath: "assets/images/FacebookLogo.png",
                                size: 30,
                                onPress: () {
                                  loginController.loginfacebook();
                                },
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              MediaTile(
                                imagePath: "assets/images/google.png",
                                size: 30,
                                onPress: () {
                                  loginController.signUpWithGoogle();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const RegisterText()
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Register Text
class RegisterText extends StatelessWidget {
  const RegisterText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: GestureDetector(
        onTap: () {
          Get.to(
            () => const SignUp(),
            transition: Transition.leftToRight,
          );
        },
        child: Container(
          margin: const EdgeInsets.only(top: 22),
          width: gWidth / 2,
          height: gHeight / 32,
          child: FittedBox(
            child: RichText(
              text: const TextSpan(
                text: "New to ARkea ?",
                style: TextStyle(color: MyColors.subTitleTextColor),
                children: [
                  TextSpan(
                    text: "  Register",
                    style: TextStyle(
                      color: MyColors.btnBorderColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Or text
class OrText extends StatelessWidget {
  const OrText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 1000),
      child: SizedBox(
        width: gWidth,
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 150,
                height: 0.2,
                color: MyColors.captionColor,
              ),
              Text(
                "  OR  ",
                style: TextStyle(color: MyColors.captionColor, fontSize: 15),
              ),
              Container(
                width: 150,
                height: 0.2,
                color: MyColors.captionColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Login Text
class LoginText extends StatelessWidget {
  const LoginText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInLeft(
      delay: const Duration(milliseconds: 2300),
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        child: const Text(
          "Log in",
          style: TextStyle(
            fontSize: 25,
            color: MyColors.titleTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Top Image
class TopImage extends StatelessWidget {
  const TopImage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 1800),
      child: SizedBox(
        width: gWidth,
        height: gHeight / 2.85,
        child: Image.asset("assets/images/logofinal.png"),
      ),
    );
  }
}
