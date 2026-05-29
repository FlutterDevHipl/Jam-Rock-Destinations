import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:solfana/Auth/Views/onboarding_auth_view.dart';
import 'package:solfana/Utils/app_colors.dart';
import 'package:solfana/Utils/app_images.dart';
import 'package:solfana/Utils/custom_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int currentIndex = 0;
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final List<Map<String, dynamic>> slides = [
    {
      "type": "onboarding",
      "image": "assets/images/onBoarding1.png",
      "title": Translation("onboarding_title_1").tr(),
      "desc": Translation("onboarding_desc_1").tr()
    },
    {
      "type": "onboarding",
      "image": "assets/images/onBoarding2.jpg",
      "title": Translation("onboarding_title_2").tr(),
      "desc": Translation("onboarding_desc_2").tr()
    },
    {
      "type": "auth", // 👈 NEW (index 3)
      "image": "assets/images/onBoarding3.png",
    },
  ];

  @override
  void initState() {
    print("Current code ${LocalizeAndTranslate.getCountryCode()}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: carouselController,
            itemCount: slides.length,
            itemBuilder: (context, index, realIndex) {
              if (slides[index]["type"] == "auth") {
                return _buildAuthSlide();
              }
              return _buildSlide(slides[index]);
            },
            options: CarouselOptions(
              height: Get.height,
              viewportFraction: 1,
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
      
          /// DOTS
          if (currentIndex < 2)
            Positioned(
              bottom: 40,
              left: 24,
              child: SafeArea(
                child: Row(
                  children: List.generate(
                    slides.length - 1,
                    (index) => Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: currentIndex == index ? 20 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color:
                            currentIndex == index ? Colors.purple : Colors.grey.shade700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
      
          /// NEXT BUTTON
          if (currentIndex < 2)
            Positioned(
              bottom: 30,
              right: 24,
              child: SafeArea(
                child: GestureDetector(
                  onTap: () {
                    if (currentIndex < slides.length - 1) {
                      carouselController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Get.to(() => LoginTypeScreen());
                    }
                  },
                  child: Container(
                    height: 48,
                    width: 48,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFA125EB),
                          Color(0xFFFD56C9),
                        ],
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// SINGLE SLIDE
  Widget _buildSlide(Map data) {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(data["image"]),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 100),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      AppColors.whiteColor,
                      AppColors.pinkColor400,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ).createShader(bounds);
                },
                child: CustomWidget().buildTextWidget(
                  title: data["title"],
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.whiteColor, 
                ),
              ),
              const SizedBox(height: 12),
              CustomWidget().buildTextWidget(
                  title: data["desc"],
                  textColor: AppColors.whiteColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 16),
              heightSpace20,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAuthSlide() {
    return Container(
      width: Get.width,
      height: Get.height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/onBoarding3.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 30),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.transparent,
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(Images.logoName),
              heightSpace10,
              ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
                    colors: [
                      AppColors.whiteColor,
                      AppColors.pinkColor400,
                    ],
                  ).createShader(bounds);
                },
                child: CustomWidget().buildTextWidget(
                  title: Translation('onboarding_title_3').tr(),
                  fontSize: 35,
                  fontWeight: FontWeight.w700,
                  textColor: Colors.white,
                ),
              ),
              heightSpace30,
              GestureDetector(
                onTap: () {
                  // Get.offAll(() => OnboardingAuthView());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border:
                        Border.all(color: AppColors.borderColor.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Images.emailIcon, width: 24, height: 18),
                      widthSpace8,
                      CustomWidget().buildTextWidget(
                          title: 'Continue with email',
                          textColor: AppColors.whiteColor,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ],
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
