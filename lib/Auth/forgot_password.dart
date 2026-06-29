import 'package:Jam_Rock_Destinations/Auth/verify_OTP.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_const.dart';
import '../Utils/custom_widget.dart';
import 'Controller/login_Controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final LoginController loginController = Get.put(LoginController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Obx(
                  () => Column(
                children: [
                  const SizedBox(height: 40),

                  /// Logo
                  Image.asset(
                    Images.logoIcon,
                    height: 90,
                  ),

                  const SizedBox(height: 24),

                  /// Title
                  CustomWidget().buildTextWidget(
                    title: "Forgot Your Password?",
                    textColor: AppColors.appColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),

                  const SizedBox(height: 6),

                  /// Subtitle
                  CustomWidget().buildTextWidget(
                    title: "We'll help you get back into your account.",
                    textColor: AppColors.black400,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),

                  const SizedBox(height: 28),

                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loginController.isEmailSelected.value = true;
                          });
                        },
                        child: _buildTab(
                          title: "Email",
                          isSelected: loginController.isEmailSelected.value,
                        ),
                      ),
                      widthSpace10,
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            loginController.isEmailSelected.value = false;
                          });
                        },
                        child: _buildTab(
                          title: "Phone Number",
                          isSelected: !loginController.isEmailSelected.value,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  /// Label
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CustomWidget().buildTextWidget(
                      title: loginController.isEmailSelected.value
                          ? "Email"
                          : "Phone Number",
                      fontSize: 14,
                      textColor: AppColors.black500,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 8),
                  if (loginController.isEmailSelected.value)
                    CustomWidget().buildTextFormField(
                      darkMode: false,
                      controller: loginController.forgotEmailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icon(
                        Icons.mail_outline,
                        size: 20,
                        color: AppColors.black500,
                      ),
                      hintText: "john@example.com",
                      radius: 8,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter your email";
                        }

                        final emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );

                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Please enter a valid email address";
                        }

                        return null;
                      },
                    )
                  else
                    CustomWidget().buildPhoneField(
                      darkMode: loginController.isDarkMode ? true : false,
                      radius: 8,
                      color: const Color(0xffF5F5F5),
                      enableCountryPicker:
                      userType != "EXPLORER" ? false : true,
                      controller: loginController.forgotPhoneController,
                      selectedCountry: loginController.selectedCountry,
                      hintText: "Enter Phone Number",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Please enter phone number";
                        }

                        if (!CustomWidget().isValidPhone(
                            value, loginController.countryName.value)) {
                          return "Enter a valid phone number";
                        }
                        // if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                        //   return "Phone number must be 10 digits";
                        // }

                        return null;
                      },
                      onCountryChanged: (country) {
                        loginController.countryCode.value = country.phoneCode;
                        loginController.countryName.value = country.countryCode;
                        print(
                          "Selected Country: ${country.name} (+${country.phoneCode}) (${country.countryCode})",
                        );
                      },
                      // maxLength: 10,
                      // validator: (value) {
                      //   if (value == null || value.trim().isEmpty) {
                      //     return "Please enter phone number";
                      //   }

                      //   if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                      //     return "Phone number must be 10 digits";
                      //   }

                      //   return null;
                      // },
                      // onCountryChanged: (country) {
                      //   loginController.countryCode.value = country.phoneCode;
                      //   print(
                      //     "Selected Country: ${country.name} (+${country.phoneCode})",
                      //   );
                      // },
                    ),

                  const SizedBox(height: 24),

                  /// Verify Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (!formKey.currentState!.validate()) {
                          return;
                        }
                        loginController.forgotStep1(
                            contactValue: loginController.isEmailSelected.value
                                ? loginController.forgotEmailController.text
                                : loginController.forgotPhoneController.text,
                            type:loginController.isEmailSelected.value?"email":"phone" , userType: userType,
                        countryCode:"+${loginController.countryCode.value.isEmpty?"1":loginController.countryCode.value}");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: loginController.isLoading.value
                          ? CustomWidget().buildTextWidget(
                          title: "Loading...", textColor: Colors.white)
                          : CustomWidget().buildTextWidget(
                        title: loginController.isEmailSelected.value
                            ? "Verify Email"
                            : "Verify Phone Number",
                        textColor: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Back To Login
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: CustomWidget().buildTextWidget(
                      title: "Back to Login",
                      textColor: AppColors.green,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
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

  Widget _buildTab({
    required String title,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.yellow50 : const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.amberColor700 : Colors.transparent,
        ),
      ),
      child: CustomWidget().buildTextWidget(
          title: title,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          textColor: isSelected ? AppColors.amberColor700 : AppColors.black300),
    );
  }
}
