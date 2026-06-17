import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../Utils/app_colors.dart';
import '../Utils/app_images.dart';
import '../Utils/custom_widget.dart';
import 'Controller/login_Controller.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  final email;
  final token;
  const CreateNewPasswordScreen({super.key, this.email, this.token});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  final LoginController loginController=Get.find<LoginController>();

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
          child: Obx(
            () =>  Column(
              children: [
                const SizedBox(height: 50),

                /// Logo
                Image.asset(
                  Images.logoIcon,
                  height: 90,
                ),

                const SizedBox(height: 30),

                /// Title
                CustomWidget().buildTextWidget(
                  title: "Create New Password",
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.appColor,
                ),

                const SizedBox(height: 8),

                /// Subtitle
                CustomWidget().buildTextWidget(
                  title: "Please enter your new password",
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black400,
                ),

                const SizedBox(height: 35),

                /// New Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomWidget().buildTextWidget(
                    title: "New Password",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black400,
                  ),
                ),

                const SizedBox(height: 8),

                /// New Password Field
                CustomWidget().buildTextFormField(
                  darkMode: true,
                  radius: 8,
                  controller: loginController.passwordController,
                  obscureText: !loginController.isPasswordVisible.value,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Enter New Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      Images.lockIcon,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        loginController.isPasswordVisible.value = !loginController.isPasswordVisible.value;
                      });
                    },
                    icon: Icon(
                      loginController.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.black300,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// Confirm Password Label
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomWidget().buildTextWidget(
                    title: "Confirm Password",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black400,
                  ),
                ),

                const SizedBox(height: 8),

                /// Confirm Password Field
                CustomWidget().buildTextFormField(
                  darkMode: true,
                  radius: 8,
                  controller: loginController.confirmPasswordController,
                  obscureText: !loginController.isConfirmPasswordVisible.value,
                  keyboardType: TextInputType.visiblePassword,
                  hintText: "Enter Confirm Password",
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      Images.lockIcon,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        loginController.isConfirmPasswordVisible.value =
                        !loginController.isConfirmPasswordVisible.value;
                      });
                    },
                    icon: Icon(
                      loginController.isConfirmPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.black300,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: ElevatedButton(
                    onPressed: () {
                      loginController.resetPassword(widget.email, loginController.passwordController.text,
                          loginController.confirmPasswordController.text,context);

                      // Reset Password API
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.green,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: CustomWidget().buildTextWidget(
                      title: "Submit",
                      textColor: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}