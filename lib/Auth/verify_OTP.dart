import 'package:Jam_Rock_Destinations/Auth/Controller/login_Controller.dart';
import 'package:Jam_Rock_Destinations/Auth/createPassword.dart';
import 'package:Jam_Rock_Destinations/Auth/saveProfile.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../Utils/app_colors.dart';

class MailVerificationScreen extends StatefulWidget {
  final isForgotScreen;
  final signupType;
  final emailorphone;
   MailVerificationScreen({super.key, this.isForgotScreen, this.signupType, this.emailorphone});
  @override
  State<MailVerificationScreen> createState() => _MailVerificationScreenState();
}
class _MailVerificationScreenState extends State<MailVerificationScreen> {
  final LoginController loginController=Get.find<LoginController>();
  final otpError = ''.obs;
  bool validateOtp() {
    if (loginController.otpController.text.length != 4) {
      otpError.value = "Please enter a valid 4-digit OTP";
      return false;
    }

    otpError.value = '';
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 50),

              /// Logo
              Image.asset(
                Images.logoIcon,
                height: 90,
              ),

              heightSpace25,

              /// Title
              CustomWidget().buildTextWidget(title: "Mail Verification",
                  textColor: Colors.black,fontWeight: FontWeight.w700,fontSize: 24),

              heightSpace5,

              /// Description
              Column(
                children: [
                  CustomWidget().buildTextWidget(
                    title: "A 4-digit code has been sent to",
                    textColor: AppColors.black400,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 2),

                  CustomWidget().buildTextWidget(
                    title: widget.emailorphone,
                    textColor: AppColors.yellow700,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              heightSpace35,

              /// OTP Fields
              Pinput(
                length: 4,
                controller: loginController.otpController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                keyboardType: TextInputType.number,
                defaultPinTheme: PinTheme(
                  width: 65,
                  height: 65,

                  decoration: BoxDecoration(
                    color: const Color(0xffF5F5F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                onChanged: (_) {
                  otpError.value = '';
                },
              ),
              heightSpace15,
              Obx(
                    () => otpError.value.isNotEmpty
                    ? Text(
                  otpError.value,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w500
                  ),
                )
                    : const SizedBox.shrink(),
              ),
              heightSpace15,

              /// Resend Code
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomWidget().buildTextWidget(
                    title: "Didn't receive a code? ",
                    textColor: AppColors.black400,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      loginController.forgotStep1(widget.emailorphone);
                    },
                    child: CustomWidget().buildTextWidget(
                      title: "Resend Code",
                      textColor: AppColors.green,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),

              heightSpace32,

              /// Submit Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    if (loginController.otpController.text.length != 4) {
                      otpError.value = "Please enter a valid 4-digit OTP";
                      return;
                    }
                   if(loginController.isEmailSelected.value)
                     {
                       loginController.verifyEmailOTp(widget.emailorphone, loginController.otpController.text, context);
                     }
                   else
                     {
                       CustomWidget().showCustomToast(message: "OTP verification from phone");
                     }


                    // if(widget.isForgotScreen)
                    //   {
                    //     Get.to(CreateNewPasswordScreen());
                    //   }
                    // else
                    //   {
                    //     Get.to(ProfileSetupScreen());
                    //     //To be navigate to home screen
                    //   }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2F8F43),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: CustomWidget().buildTextWidget(
                    title: loginController.isLoading.value ? "Loading..." : "Submit",
                    textColor: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// Change Email
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: CustomWidget().buildTextWidget(
                  title: "Change Email Address?",
                  textColor: AppColors.green,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}