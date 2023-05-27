import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../ViewModel/signup_controller.dart';
import '../../../Views/screens/auth/login_page.dart';
import '../../../utils/colors.dart';
import '../../../utils/sizes.dart';
import '../../widgets/form_textfiled.dart';
import '../../widgets/media_tile.dart';
import '../../widgets/sp_solid_button.dart';

var signUpController = Get.put(SignupScreenController());

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Scaffold(
          body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.center,
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const TopImage(),
                    const LoginText(),
                    const SizedBox(height: 10),
                    FadeInDown(
                      delay: const Duration(milliseconds: 2900),
                      child: FormTextFiled(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              signUpController.validName.value = false;
                              return "Field could not be Empty";
                            } else {
                              signUpController.validName.value = true;
                              return null;
                            }
                          },
                          controller: signUpController.nameEditingController,
                          typeInput: TextInputType.text,
                          prefIcon: Icon(
                            Icons.person_2_outlined,
                            color: MyColors.captionColor,
                          ),
                          sufIcon: null,
                          label: "Name"),
                    ),
                    const SizedBox(height: 20),
                    FadeInDown(
                      delay: const Duration(milliseconds: 2900),
                      child: FormTextFiled(
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Field could not be Empty";
                            } else if (!GetUtils.isEmail(value)) {
                              signUpController.validEmail.value = false;
                              return "Please Enter a Valid Email";
                            } else {
                              signUpController.validEmail.value = true;

                              return null;
                            }
                          },
                          controller: signUpController.emailEditingController,
                          typeInput: TextInputType.emailAddress,
                          prefIcon: Icon(
                            Icons.email_outlined,
                            color: MyColors.captionColor,
                          ),
                          sufIcon: null,
                          label: "Email"),
                    ),
                    const SizedBox(height: 20),
                    // PasswordTextFiled(),
                    const checkBox(),

                    const SizedBox(
                      height: 25,
                    ),
                    FadeInDown(
                      delay: const Duration(milliseconds: 1400),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        width: gWidth / 2,
                        height: gHeight / 12,
                        // child: Obx(
                        //   () => signUpController.checkboxValue.value &&
                        //           signUpController.validName.value &&
                        //           signUpController.validEmail.value
                        //       ? SPSolidButton(
                        //           backgroundColor: MaterialStateProperty.all(
                        //               MyColors.btnColor),
                        //           text: "Sign Up",
                        //           minWidth: 0,
                        //           onPressed: () {
                        //             signUpController.signUp();
                        //           })
                        //       : SPSolidButton(
                        //           backgroundColor: MaterialStateProperty.all(
                        //               MyColors.btnColor.withOpacity(0.7)),
                        //           text: "Sign Up",
                        //           minWidth: 0,
                        //           onPressed: null),
                        // )

                        child: Obx(
                          () {
                            return ElevatedButton(
                              style: signUpController.checkboxValue.value &&
                                      signUpController.validName.value &&
                                      signUpController.validEmail.value
                                  ? ElevatedButton.styleFrom(
                                      fixedSize: const Size(50, 50),
                                      backgroundColor: MyColors.btnColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )
                                  : ElevatedButton.styleFrom(
                                      fixedSize: const Size(50, 50),
                                      backgroundColor:
                                          MyColors.btnColor.withOpacity(0.7),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                              onPressed: signUpController.checkboxValue.value &&
                                      signUpController.validName.value &&
                                      signUpController.validEmail.value
                                  ? () async {
                                      signUpController.signUp();
                                    }
                                  : null,
                              child: signUpController.isLogginIn.value
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ),
                    ),
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
                                signUpController.signUpWithFacebook();
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MediaTile(
                              imagePath: "assets/images/google.png",
                              size: 30,
                              onPress: () {
                                signUpController.signUpWithGoogle();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const signinText()
                  ]),
            ),
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
          "Sign Up",
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

// Register Text
// ignore: camel_case_types
class signinText extends StatelessWidget {
  const signinText({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      child: GestureDetector(
        onTap: () {
          Get.offAll(
            () => const LoginPage(),
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
                text: "Already have an account?",
                style: TextStyle(color: MyColors.subTitleTextColor),
                children: [
                  TextSpan(
                    text: " Log In",
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

// Or Text
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

// Login Button
class SignupButton extends StatelessWidget {
  const SignupButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 1400),
      child: Container(
        margin: const EdgeInsets.all(15),
        width: gWidth / 2,
        height: gHeight / 12,
        child: SPSolidButton(
          backgroundColor: MaterialStateProperty.all(MyColors.btnColor),
          text: "Sign Up",
          minWidth: 0,
          onPressed: () {
            signUpController.signUp();
          },
        ),
      ),
    );
  }
}

// ignore: camel_case_types
class checkBox extends StatefulWidget {
  const checkBox({super.key});

  @override
  State<checkBox> createState() => _checkBoxState();
}

// ignore: camel_case_types
class _checkBoxState extends State<checkBox> {
  @override
  Widget build(BuildContext context) {
    return FadeInDown(
      delay: const Duration(milliseconds: 2300),
      child: FormField<bool>(
        builder: (state) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Checkbox(
                      activeColor: MyColors.btnBorderColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      value: signUpController.checkboxValue.value,
                      onChanged: (value) {
                        signUpController.checkboxValue.value = value!;
                        state.didChange(value);
                      }),
                  RichText(
                      text: const TextSpan(
                    children: [
                      TextSpan(
                          text: "BY continueing, I agree to the ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          )),
                      TextSpan(
                          text: " Terms of use ",
                          style: TextStyle(
                            color: MyColors.titleTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                      TextSpan(
                          text: " & ",
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          )),
                      TextSpan(
                          text: " Privacy & Policy",
                          style: TextStyle(
                            color: MyColors.titleTextColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          )),
                    ],
                  )),
                ],
              ),
            ],
          );
        },
        //output from validation will be displayed in state.errorText (above)
        validator: (value) {
          if (!signUpController.checkboxValue.value) {
            return 'You need to accept terms';
          } else {
            return null;
          }
        },
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
      delay: const Duration(milliseconds: 3800),
      child: SizedBox(
        width: gWidth,
        height: gHeight / 2.85,
        child: Image.asset("assets/images/logofinal.png"),
      ),
    );
  }
}
