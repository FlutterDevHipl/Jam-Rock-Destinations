import 'package:Jam_Rock_Destinations/Auth/Login_View.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get_storage/get_storage.dart';

import '../Utils/app_const.dart';
import '../Utils/storage.dart';
import 'onBoardingScreen.dart';

class SelectRoleScreen extends StatefulWidget {
  const SelectRoleScreen({super.key});

  @override
  State<SelectRoleScreen> createState() => _SelectRoleScreenState();
}

class _SelectRoleScreenState extends State<SelectRoleScreen> {
  int selectedIndex = 0;
  final box = GetStorage();
  bool seenOnboarding = false;
  bool _showOnboarding = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    seenOnboarding = box.read('seenOnboarding') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Image.asset(
                Images.logoIcon,
                height: 90,
              ),
              const SizedBox(height: 40),
              CustomWidget().buildTextWidget(
                  title: "How would you like to\ncontinue?",
                  fontSize: 24,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black500),

              const SizedBox(height: 50),
              Row(
                children: [
                  Expanded(
                    child: roleCard(
                      index: 0,
                      title: "I'm a Explorer",
                      subtitle: "Book rides & explore destinations",
                      image: Images.explorerIcon,
                      iconImage: Images.personLogo,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: roleCard(
                      index: 1,
                      title: "I'm a Driver",
                      subtitle: "Accept rides & earn on your terms",
                      image: Images.driverLogo,
                      iconImage: Images.steeringIcon,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // SizedBox(
              //   width: double.infinity,
              //   height: 55,
              //   child: ElevatedButton(
              //
              //       onPressed: () {
              //         final userTypes =
              //             selectedIndex == 0 ? 'EXPLORER' : 'DRIVER';
              //         userBox.put('user_type', userTypes);
              //         userType = userTypes;
              //         debugPrint(userBox.get('user_type'));
              //         debugPrint("App const = $userType");
              //
              //         Get.to(() => OnboardingScreen());
              //       },
              //       style: ElevatedButton.styleFrom(
              //         backgroundColor: const Color(0xff2F8F3A),
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(8),
              //         ),
              //       ),
              //       child: CustomWidget().buildTextWidget(
              //           title: "Continue",
              //           fontSize: 16,
              //           textColor: Colors.white)),
              // ),
              CustomWidget().buildMaterialBtn(
                text: "Continue",
                color: AppColors.green500,
                radius: 8,
                onPressed: () {
                  final userTypes = selectedIndex == 0 ? 'EXPLORER' : 'DRIVER';
                  userBox.put('user_type', userTypes);
                  userType = userTypes;
                  debugPrint(userBox.get('user_type'));
                  debugPrint("App const = $userType");

                  // Get.to(() => OnboardingScreen());

                  if (_showOnboarding) {
                    setState(() {
                      _showOnboarding = false;
                    });
                  }
                  !seenOnboarding
                      ? Get.to(const OnboardingScreen())
                      : Get.to(() => const LoginScreen());
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget roleCard({
    required int index,
    required String title,
    required String subtitle,
    required String image,
    required String iconImage,
  }) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 220,
              minHeight: 200,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              // height: Get.height * 0.26,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? AppColors.green500 : AppColors.black50,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    image,
                    height: 90,
                  ),
                  const SizedBox(height: 16),
                  Padding(
                      padding:
                          // EdgeInsetsGeometry.symmetric(horizontal: 10),
                          EdgeInsets.symmetric(horizontal: 5),
                      child: CustomWidget().buildTextWidget(
                          title: title,
                          textAlign: TextAlign.center,
                          textColor: isSelected
                              ? AppColors.green500
                              : AppColors.black400,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                  const SizedBox(height: 8),
                  CustomWidget().buildTextWidget(
                      title: subtitle,
                      textAlign: TextAlign.center,
                      textColor: AppColors.black400,
                      fontSize: 13),
                  heightSpace5
                ],
              ),
            ),
          ),
          Positioned(
            bottom: -22,
            child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? const Color(0xffEAF6EC)
                      : Colors.grey.shade100,
                  border: Border.all(
                    color: isSelected ? AppColors.green500 : Colors.transparent,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    iconImage,
                    color: isSelected ? AppColors.green500 : Colors.grey,
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
