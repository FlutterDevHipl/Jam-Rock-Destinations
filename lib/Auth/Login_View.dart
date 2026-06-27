import 'package:Jam_Rock_Destinations/Auth/forgot_password.dart';
import 'package:Jam_Rock_Destinations/Auth/registration_View.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';
import 'package:get_storage/get_storage.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../Utils/app_const.dart';
import '../Utils/app_images.dart';
import '../Utils/custom_widget.dart';
import 'Controller/login_Controller.dart';



class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  final box = GetStorage();
  final LoginController loginController=Get.put(LoginController());
  // final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  // final passwordController = TextEditingController();



  int maxLength = 10;

  @override
  void initState() {
    super.initState();
    box.write('seenOnboarding', true);
  }


  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    loginController.getFirebaseToken();
    return
      Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                heightSpace30,
                /// Logo
                Image.asset(
                  Images.logoIcon,
                  height: Get.height * .10,
                ),

                heightSpace25,

                CustomWidget().buildTextWidget(
                  title: "Login to your Account",
                  fontSize: 24,
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                ),

                heightSpace5,

                CustomWidget().buildTextWidget(
                  title: "Your next destination awaits",
                  fontSize: 16,
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                ),

                heightSpace35,

                /// Tabs
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEmailSelected = true;
                        });
                      },
                      child: _buildTab(
                        title: "Email",
                        isSelected: isEmailSelected,
                      ),
                    ),
                    widthSpace10,
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isEmailSelected = false;
                        });
                      },
                      child: _buildTab(
                        title: "Phone Number",
                        isSelected: !isEmailSelected,
                      ),
                    ),
                  ],
                ),

                heightSpace25,

                /// Email
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomWidget().buildTextWidget(
                    title: isEmailSelected ? "Email" : "Phone Number",
                    fontSize: 14,
                    textColor: AppColors.black300,
                    fontWeight: FontWeight.w600,
                  ),

                ),

                heightSpace8,

                if (isEmailSelected)
                  CustomWidget().buildTextFormField(
                    darkMode: true,
                    radius: 8,
                    controller: loginController.emailController,
                    hintText: "Enter Your Email",
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(14),
                      child: SvgPicture.asset(Images.messageIcon),
                    ),
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
                    darkMode: loginController.isDarkMode?true:false,
                    radius: 8,
                    color:  const Color(0xffF5F5F5),
                    enableCountryPicker:userType != "EXPLORER"?false:true,
                    controller: loginController.phoneController,
                    selectedCountry: loginController.selectedCountry,
                    hintText: "Enter Phone Number",
                    // maxLength: 10,
                    validator: (value) {
                      print("Value $value");
                      print(loginController.countryName.value);
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter phone number";
                      }

                      if (!isValidPhone(
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
                    // onCountryChanged: (country) {
                    //   loginController.countryCode.value=country.phoneCode;
                    //   print(
                    //     "Selected Country: ${country.name} (+${country.phoneCode})",
                    //   );
                    // },
                  ),

                heightSpace24,

                /// Password
                Align(
                  alignment: Alignment.centerLeft,
                  child: CustomWidget().buildTextWidget(
                    title: "Password",
                    fontSize: 14,
                    textColor: AppColors.black300,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                heightSpace8,
                CustomWidget().buildTextFormField(
                  darkMode: true,
                  radius: 8,
                  hintText: "Enter Your Password",
                  controller: loginController.passwordController,
                  obscureText: !isPasswordVisible,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(Images.lockIcon),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.black38,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter your password";
                    }

                    if (value.length < 8) {
                      return "Password must be at least 8 characters";
                    }

                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return "Password must contain at least one uppercase letter";
                    }

                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return "Password must contain at least one lowercase letter";
                    }

                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return "Password must contain at least one number";
                    }

                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return "Password must contain at least one special character";
                    }

                    return null;
                  },
                ),

                heightSpace15,

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: () {
                      Get.to(ForgotPasswordScreen());
                      },
                    child: CustomWidget().buildTextWidget(
                      title: "Forgot your password?",
                      fontSize: 16,
                      textColor:AppColors.green500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                heightSpace30,

                Obx(
                  () =>  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {

                        if (!formKey.currentState!.validate()) {
                          return;
                        }

                        final identifier = isEmailSelected
                            ? loginController.emailController.text.trim()
                            : "+${loginController.countryCode.value}${loginController.phoneController.text.trim()}";
                        debugPrint(
                            "Login Type: ${isEmailSelected ? "EMAIL" : "PHONE"}");

                        debugPrint("Identifier: $identifier");

                        debugPrint("Password: ${loginController.passwordController.text}");
                        loginController.login(identifier, loginController.passwordController.text);



                        // Call Login API
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green500,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: CustomWidget().buildTextWidget(
                        title: loginController.isLoading.value?"Loading...":"Login",
                        textColor: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                heightSpace30,

                Row(
                  children: [
                    const Expanded(child: Divider(color: Colors.black12,)),
                    widthSpace15,
                    CustomWidget().buildTextWidget(
                      title: "Or",
                      fontSize: 14,
                      textColor: Colors.black,
                    ),
                    widthSpace15,
                    const Expanded(child: Divider(color: Colors.black12)),
                  ],
                ),

                heightSpace25,

                Row(
                  children: [
                    Expanded(
                      child:
                      GestureDetector(
                        onTap: () {
                          loginController.signInWithApple();
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.14),
                                blurRadius: 27.8,
                                offset: const Offset(0, 0),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.apple),
                              widthSpace8,
                              CustomWidget().buildTextWidget(
                                title:"Apple",
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                textColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                      )
                      // _socialButton(
                      //   icon: Icons.apple,
                      //   title: "Apple",
                      // ),
                    ),
                    widthSpace15,
                    Expanded(
            child: GestureDetector(
              onTap: () {
                loginController.signInWithGoogle();
              },
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.14),
                      blurRadius: 27.8,
                      offset: const Offset(0, 0),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                     SvgPicture.asset(Images.googleLogo,),
                    widthSpace8,
                    CustomWidget().buildTextWidget(
                      title: "Google",
                      fontSize: 14,
                      textColor: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
                    )
                  ],
                ),

                heightSpace24,

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget().buildTextWidget(
                      title: "Don't have an account? ",
                      textColor: AppColors.black400,
                      fontWeight: FontWeight.w400,
                      fontSize: 16
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(RegistrationView(socialUserId: "",isSocialLogin: false,
                        image: "",fullname: "",email: "",socialType: "normal",));
                      },
                      child:    CustomWidget().buildTextWidget(
                      title: "Register Now",

                      textColor: AppColors.green500,
                      fontWeight: FontWeight.w600,
                    ),)

                  ],
                ),
              ],
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
        color: isSelected
            ?
        AppColors.yellow50
            : const Color(0xffF5F5F5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.amberColor700
              : Colors.transparent,
        ),
      ),
      child: CustomWidget().buildTextWidget(
        title: title,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        textColor: isSelected
            ? AppColors.amberColor700
            : AppColors.black300
      ),
    );
  }
  bool isValidPhone(String number, String isoCode) {
    try {
      final phone = PhoneNumber.parse(
        number,
        destinationCountry: IsoCode.values.byName(isoCode),
      );

      return phone.isValid();
    } catch (_) {
      return false;
    }
  }
  // Widget _socialButton({
  //   IconData? icon,
  //   String? image,
  //   required String title,
  //
  // }) {
  //   return
  //     Container(
  //     height: 55,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(10),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Colors.black.withOpacity(0.14),
  //           blurRadius: 27.8,
  //           offset: const Offset(0, 0),
  //           spreadRadius: 0,
  //         ),
  //       ],
  //     ),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         if (icon != null)
  //           Icon(
  //             icon,
  //             color: Colors.black,
  //           ),
  //
  //         if (image != null)
  //           Image.asset(
  //             image,
  //             height: 22,
  //           ),
  //
  //         widthSpace8,
  //
  //         CustomWidget().buildTextWidget(
  //           title: title,
  //           fontSize: 16,
  //           fontWeight: FontWeight.w400,
  //           textColor: Colors.black,
  //         ),
  //       ],
  //     ),
  //   );
  // }
}