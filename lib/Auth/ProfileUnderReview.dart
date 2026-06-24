import 'package:Jam_Rock_Destinations/Auth/Login_View.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../Utils/app_colors.dart';
import '../Utils/custom_widget.dart';
import 'Controller/Driver_Registration.dart';

class ProfileReviewView extends StatefulWidget {
  final token;

  const ProfileReviewView({super.key, this.token, });

  @override
  State<ProfileReviewView> createState() => _ProfileReviewViewState();
}

class _ProfileReviewViewState extends State<ProfileReviewView> {
  final VehicleDetailsController controller = Get.put(VehicleDetailsController());
  // @override
  // void initState() {
  //   super.initState();
  //
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     controller.driverRegistration3(widget.token);
  //   });
  // }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Column(
            children: [
              // const SizedBox(height: 40),

              /// Title
              CustomWidget().buildTextWidget(
                title: "Profile Review",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                textColor: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),
              heightSpace25,
              const Spacer(),

              /// Image
              Image.asset(
                Images.profileReview,
                height: Get.height * 0.40,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 40),

              /// Heading
              CustomWidget().buildTextWidget(
                title: "Profile Under Review",
                fontSize: 24,
                fontWeight: FontWeight.w700,
                textColor: AppColors.blackColor,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              /// Success Text
              CustomWidget().buildTextWidget(
                title:
                "Your documents have been submitted\nsuccessfully.",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black400,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              /// Description
              CustomWidget().buildTextWidget(
                title:
                "This usually takes 24–48 hours. We'll notify you via email once verified.",
                fontSize: 16,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black400,
                textAlign: TextAlign.center,
              ),
              heightSpace10,
              const Spacer(),

              /// Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {

                    Get.offAll(LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.green500,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: CustomWidget().buildTextWidget(
                    title: "Okay, Got It",
                    textColor: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}