import 'dart:ui';
import 'package:Jam_Rock_Destinations/Customer/customer_bottom_navigation.dart';
import 'package:Jam_Rock_Destinations/WelcomeScreens/select_role.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:localize_and_translate/localize_and_translate.dart';

import '../Utils/AppGradients.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_const.dart';
import '../Utils/app_images.dart';
import '../Utils/custom_widget.dart';
import '../Utils/storage.dart';
import 'onBoardingScreen.dart';


class Splashscreen extends StatefulWidget {
  const Splashscreen({super.key});

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
print("User id ${getUserId()}");

    print("usertype = $userType");
    Future.delayed(const Duration(seconds: 3), () {
      if (getUserId() == null || getUserId().isEmpty) {
        Get.offAll(() => SelectRoleScreen());
      } else {
        String role = userBox.get("user_type");
        userType=role;
        Get.offAll(CustomerBottomNavigation());
      }
      // Get.offAll(() => SelectRoleScreen());
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child:Image.asset(Images.logoIcon),),
        ],
      ),
    );
  }
}
