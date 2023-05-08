import 'package:ARkea/Views/screens/landing_page.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../Model/boarding_items_model.dart';
import '../../../utils/colors.dart';
import 'GetStartBtnBoardingPage.dart';

class boradingScreen extends StatefulWidget {
  const boradingScreen({super.key});

  @override
  State<boradingScreen> createState() => _boradingScreenState();
}

class _boradingScreenState extends State<boradingScreen> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndex = 0;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  Widget animation(
    int index,
    int delay,
    Widget child,
  ) {
    if (index == 1) {
      return FadeInDown(
        delay: Duration(milliseconds: delay),
        child: child,
      );
    }
    return FadeInUp(
      delay: Duration(milliseconds: delay),
      child: child,
    );
  }

  Future setSeenonboard() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var seenOnboard = await prefs.setBool('seenOnboard', true);
    // this will set seenOnboard to true when running onboard page for first time.
  }

  @override
  void initState() {
    super.initState();
    setSeenonboard();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return SafeArea(
      child: Scaffold(
          body: SizedBox(
        width: size.width,
        height: size.height,
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: PageView.builder(
                controller: pageController,
                itemCount: listOfItems.length,
                onPageChanged: (newIndex) {
                  setState(() {
                    currentIndex = newIndex;
                  });
                },
                physics: const BouncingScrollPhysics(),
                itemBuilder: ((context, index) {
                  return SizedBox(
                    width: size.width,
                    height: size.height,
                    child: Column(
                      children: [
                        /// IMG
                        Container(
                          margin: const EdgeInsets.fromLTRB(15, 40, 15, 10),
                          width: size.width,
                          height: size.height / 2.5,
                          child: animation(
                            index,
                            100,
                            Image.asset(listOfItems[index].img),
                          ),
                        ),

                        /// TITLE TEXT
                        Padding(
                            padding: const EdgeInsets.only(top: 25, bottom: 15),
                            child: animation(
                              index,
                              300,
                              Text(
                                listOfItems[index].title,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 25,
                                  color: MyColors.titleTextColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )),

                        /// SUBTITLE TEXT
                        animation(
                          index,
                          500,
                          Text(
                            listOfItems[index].subTitle,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontSize: 18,
                                color: MyColors.subTitleTextColor,
                                fontWeight: FontWeight.w400,
                                wordSpacing: 1.2,
                                height: 1.2),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),

            /// ---------------------------
            Expanded(
              flex: 1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// PAGE INDICATOR
                  SmoothPageIndicator(
                    controller: pageController,
                    count: listOfItems.length,
                    effect: const ExpandingDotsEffect(
                      spacing: 6.0,
                      radius: 10.0,
                      dotWidth: 10.0,
                      dotHeight: 10.0,
                      expansionFactor: 3.8,
                      dotColor: Colors.grey,
                      activeDotColor: MyColors.btnColor,
                    ),
                    onDotClicked: (newIndex) {
                      setState(() {
                        currentIndex = newIndex;
                        pageController.animateToPage(newIndex,
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      });
                    },
                  ),
                  currentIndex == 2

                      /// GET STARTED BTN
                      ? Container(
                          margin: const EdgeInsets.only(top: 60),
                          width: size.width / 1.5,
                          height: size.height / 13,
                          decoration: BoxDecoration(
                              color: MyColors.btnBorderColor,
                              border: Border.all(
                                color: MyColors.btnBorderColor,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(15)),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(15.0),
                            onTap: () {
                              Get.offAll(
                                () => const LandingPage(),
                                transition: Transition.leftToRight,
                              );
                            },
                            splashColor: MyColors.btnBorderColor,
                            child: const Center(
                              child: Text(
                                "Get Started now",
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        )

                      /// SKIP BTN
                      : SkipBtn(
                          size: size,
                          textTheme: textTheme,
                          onTap: () {
                            setState(() {
                              pageController.animateToPage(2,
                                  duration: const Duration(milliseconds: 1000),
                                  curve: Curves.fastOutSlowIn);
                            });
                          },
                        )
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
