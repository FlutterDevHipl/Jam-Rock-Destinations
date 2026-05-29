import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:solfana/Utils/AppGradients.dart';
import 'package:solfana/Utils/app_colors.dart';
import 'package:solfana/Utils/app_images.dart';
import 'package:solfana/Utils/custom_widget.dart';
import 'package:solfana/Utils/storage.dart';
import 'package:solfana/WelcomeScreens/onBoardingScreen.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  final selectedLang = "en".obs;

  @override
  void initState() {
    super.initState();
    LocalizeAndTranslate.setLanguageCode(
        selectedLang.value);
    Future.delayed(const Duration(seconds: 3), () {
      if (getUserId() == null || getUserId().isEmpty) {
        // Get.offAll(() => DashboardScreen(currentIndex: 0));
        Get.offAll(() => OnboardingScreen());
        // showLanguagePopup();
      } else {
        // Get.offAll(() => DashboardScreen(
        //       currentIndex: 0,
        //     ));
      }
    });
    

    // _initInBackground();
  }

//   Future<void> _initInBackground() async {
//   await Future.wait([
//     MobileAds.instance.initialize(),      // Only once here ✅
//     JustAudioBackground.init(
//       androidNotificationChannelId: 'com.solfana',
//       androidNotificationChannelName: 'Audio Playback',
//       androidNotificationOngoing: true,
//     ),
//   ]);

//   Get.put(PlayerController(), permanent: true);
// }


  void showLanguagePopup() {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      useRootNavigator: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            SystemNavigator.pop();
            return false;
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: EdgeInsets.symmetric(horizontal: 16),
            backgroundColor: Colors.transparent,
            child: Builder(
              builder: (context) {
                return IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xff01061B).withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        width: 1,
                        color: AppColors.borderColor.withOpacity(0.2),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff01061B).withOpacity(0.25),
                          offset: const Offset(0, 25),
                          blurRadius: 47.6,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
                      child: Obx(
                        () => Container(
                          width: Get.width * 0.95,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.borderColor.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CustomWidget().buildTextWidget(
                                title: Translation('Choose Language').tr(),
                                fontWeight: FontWeight.w700,
                                textColor: Colors.white,
                                fontSize: 24,
                              ),
                              heightSpace35,
                              _languageTile(
                                code: "fr",
                                title: "French",
                                flag: Images.franceFlagIcon,
                              ),
                              heightSpace2,
                              _languageTile(
                                code: "en",
                                title: "English",
                                flag: Images.usFlagIcon,
                              ),
                              heightSpace40,
                              InkWell(
                                borderRadius: BorderRadius.circular(30),
                                onTap: () {
                                  LocalizeAndTranslate.setLanguageCode(
                                      selectedLang.value);
                                  Get.back();
                                  Get.offAll(() => OnboardingScreen());
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(15),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: AppGradients.pinkPurple,
                                  ),
                                  child: CustomWidget().buildTextWidget(
                                    title: Translation('Continue').tr(),
                                    textColor: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              heightSpace25,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  /// Reusable Language Tile
  Widget _languageTile({
    required String code,
    required String title,
    required String flag,
  }) {
    final isSelected = selectedLang.value == code;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
        side:
            BorderSide(color: AppColors.borderColor.withOpacity(0.2), width: 1),
      ),
      color: isSelected ? AppColors.borderColor : Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {
          selectedLang.value = code;
          debugPrint("Selected language: $code");
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            children: [
              Container(
                  color: AppColors.whiteColor,
                  child: SvgPicture.asset(flag, height: 24)),
              const SizedBox(width: 12),
              CustomWidget().buildTextWidget(
                title: title,
                fontWeight: FontWeight.w400,
                textColor:
                    isSelected ? AppColors.blackColor : AppColors.whiteColor,
                fontSize: 16,
              ),
              const Spacer(),
              SvgPicture.asset(
                isSelected
                    ? Images.selectedRadioButton
                    : Images.unselectedRadioButton,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: SvgPicture.asset(Images.logoIcon)),
          heightSpace30,
          // CustomWidget().buildTextWidget(
          //   title: Translation("splash_tagline").tr(),
          //   textColor: Colors.white,
          // ),
        ],
      ),
    );
  }
}
