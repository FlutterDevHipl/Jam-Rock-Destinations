import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:get_storage/get_storage.dart';

import '../Auth/Login_View.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController pageController = PageController();

  int currentIndex = 0;
  final box = GetStorage();
  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/image/onBoardingOne.png",
      "title": "Explore destinations\nin Jamaica",
      "desc": "Find rides to the places you love",
    },
    {
      "image": "assets/image/onBoardingTwo.png",
      "title": "Book in minutes",
      "desc": "Book your ride in just a few taps.",
    },
    {
      "image": "assets/image/onBoardingThree.png",
      "title": "Travel with trusted drivers",
      "desc": "Verified. Rated. Ready.",
    },
  ];
  final List<Map<String, String>> driverOnboardingData = [
    {
      "image": Images.driverOnboarding1,
      "title": "Earn on Your Terms",
      "desc": "Accept rides anytime, on your schedule.",
    },
    {
      "image": Images.driverOnboarding2,
      "title": "Grow With Every Trip",
      "desc": "Track earnings and get more bookings.",
    },
    {
      "image": Images.driverOnboarding3,
      "title": "Get Started in Minutes",
      "desc": "Upload docs, get verified, start earning.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: PageView.builder(
          controller: pageController,
          itemCount: userType == "customer"
              ? onboardingData.length
              : driverOnboardingData.length,
          onPageChanged: (index) {
            setState(() {
              currentIndex = index;
            });
            box.write('seenOnboarding', true);
          },
          itemBuilder: (context, index) {
            final item = userType == "customer"
                ? onboardingData[index]
                : driverOnboardingData[index];

            return Padding(
              padding: const EdgeInsets.only(top: 24, left: 16, right: 16),
              child: Stack(
                children: [
                  Column(
                    children: [
                      heightSpace10,
                      Spacer(),

                      /// Illustration
                      Image.asset(
                        item["image"]!,
                        height: Get.height * 0.5,
                        fit: BoxFit.contain,
                      ),
                      heightSpace30,

                      /// Title
                      CustomWidget().buildTextWidget(
                        title: item["title"]!,
                        textAlign: TextAlign.center,
                        textColor: AppColors.black500,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),

                      const SizedBox(height: 8),

                      /// Description
                      CustomWidget().buildTextWidget(
                        title: item["desc"]!,
                        textAlign: TextAlign.center,
                        textColor: AppColors.black400,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                      heightSpace24,

                      /// Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          onboardingData.length,
                          (dotIndex) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: currentIndex == dotIndex ? 20 : 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: currentIndex == dotIndex
                                  ? AppColors.yellow600
                                  : AppColors.yellow100,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),

                      const Spacer(),

                      /// Bottom Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                            onPressed: () {
                              if (currentIndex < onboardingData.length - 1) {
                                pageController.nextPage(
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              } else {
                                box.write('seenOnboarding', true);

                                /// Navigate
                                Get.off(() => LoginScreen());
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff2F8F3A),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomWidget().buildTextWidget(
                                    title: currentIndex ==
                                            onboardingData.length - 1
                                        ? "Get Started"
                                        : "Next",
                                    textColor: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500),
                                widthSpace5,
                                currentIndex == onboardingData.length - 1
                                    ? SizedBox()
                                    : Icon(
                                        Icons.arrow_forward_outlined,
                                        color: Colors.white,
                                      )
                              ],
                            )),
                      ),

                      SizedBox(height: Get.height * .03),
                    ],
                  ),

                  /// Top Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        Images.logoIcon,
                        height: 100,
                      ),
                      if (currentIndex != onboardingData.length - 1)
                        OutlinedButton(
                          onPressed: () {
                            // pageController.animateToPage(
                            //   onboardingData.length - 1,
                            //   duration: const Duration(milliseconds: 300),
                            //   curve: Curves.easeInOut,
                            // );
                            box.write('seenOnboarding', true);
                            Get.off(() => LoginScreen());
                          },
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size(65, 30),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              side: BorderSide(
                                  color: AppColors.amberColor700, width: 1),
                              shape: const StadiumBorder(),
                              backgroundColor: AppColors.yellow50),
                          child: CustomWidget().buildTextWidget(
                              title: "Skip",
                              textColor: AppColors.amberColor700,
                              fontSize: 14),
                        )
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
