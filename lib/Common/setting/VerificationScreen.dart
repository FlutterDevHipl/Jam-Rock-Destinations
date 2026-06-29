import 'package:Jam_Rock_Destinations/Auth/Controller/login_Controller.dart';
import 'package:Jam_Rock_Destinations/Auth/createPassword.dart';
import 'package:Jam_Rock_Destinations/Auth/saveProfile.dart';
import 'package:Jam_Rock_Destinations/Common/controller/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

import '../../Utils/app_colors.dart';

class VerificationScreen extends StatefulWidget {
  final signupType;
  final emailorphone;
  final countryCode;
  VerificationScreen({super.key, this.signupType, this.emailorphone, this.countryCode});
  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}
class _VerificationScreenState extends State<VerificationScreen> {
  final ProfileController profileController=Get.find<ProfileController>();
  final otpError = ''.obs;
  bool validateOtp() {
    if (profileController.otpController.text.length != 4) {
      otpError.value = "Please enter a valid 4-digit OTP";
      return false;
    }

    otpError.value = '';
    return true;
  }
  String maskPhoneNumber(String phone, String countryCode) {
    phone = phone.replaceAll('+', '');

    if (phone.startsWith(countryCode)) {
      phone = phone.substring(countryCode.length);
    }

    String start2 = phone.substring(0, 2);
    String last2 = phone.substring(phone.length - 2);

    return '${start2}X XXX XX$last2';
  }
  @override
  Widget build(BuildContext context) {
    final isNumber = num.tryParse(widget.emailorphone.toString()) != null;
    print("countryCode${widget.countryCode}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Contact Update",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
              CustomWidget().buildTextWidget(title:widget.signupType=="email"? "Mail Verification":"Phone Number Verification",
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
                    title: isNumber
                        ? '${widget.countryCode} ${maskPhoneNumber(widget.emailorphone, widget.countryCode)}'
                        : widget.emailorphone,
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
                controller: profileController.otpController,
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
                      profileController.sendVerificationOTp(widget.emailorphone, widget.signupType, context,profileController.selectedCountry.value);
                      // loginController.forgotStep1(widget.emailorphone);
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
              Obx(
                () =>  SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      if (profileController.otpController.text.length != 4) {
                        otpError.value = "Please enter a valid 4-digit OTP";
                        return;
                      }
                      if(widget.signupType=="email")
                        {
                          profileController.verifyOTp(widget.emailorphone, widget.signupType,
                              profileController.otpController.text, context,"");
                        }
                      else{
                        profileController.verifyOTp
                          (
                            widget.emailorphone,
                          widget.signupType,
                            profileController.otpController.text,
                          context,
                          widget.countryCode
                           );
                      }

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2F8F43),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomWidget().buildTextWidget(
                      title: profileController.isLoading.value ? "Loading..." : "Submit",
                      textColor: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
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
                  title: widget.signupType=="email"?"Change Email Address?":"Change Phone Number?",
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