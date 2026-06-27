import 'package:Jam_Rock_Destinations/Auth/Controller/registration_Controller.dart';
import 'package:Jam_Rock_Destinations/Auth/Login_View.dart';
import 'package:Jam_Rock_Destinations/Common/setting/TermsAndConditions.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

import '../Common/setting/PrivacyPolicy.dart';
import '../Utils/app_images.dart';
import '../Utils/custom_widget.dart';

class RegistrationView extends StatefulWidget {
  final fullname;
  final email;
  final socialUserId;

  final isSocialLogin;
  final image;
  final socialType;
  final countryCode;
  const RegistrationView(
      {super.key,
      this.fullname,
      this.email,
      this.isSocialLogin,
      this.image,
      this.socialUserId, this.socialType, this.countryCode,

      });

  @override
  State<RegistrationView> createState() => _RegistrationViewState();
}

class _RegistrationViewState extends State<RegistrationView> {
  final RegistrationController registrationController =
      Get.put(RegistrationController());

  @override
  Widget build(BuildContext context) {
    print("widget.image ${widget.image}");
    registrationController.getFirebaseToken();
    if (widget.isSocialLogin == true) {
      registrationController.nameController.text = widget.fullname.toString();
      registrationController.emailController.text = widget.email.toString();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Form(
            key: registrationController.formKey,
            child: Obx(
              () => Stack(
                children: [
                  Column(
                    children: [
                      heightSpace20,

                      /// Logo
                      Image.asset(
                        Images.logoIcon,
                        height: Get.height * .10,
                      ),

                      heightSpace24,

                      CustomWidget().buildTextWidget(
                        title: "Create Account",
                        fontSize: 24,
                        textColor: Colors.black,
                        fontWeight: FontWeight.w700,
                        textAlign: TextAlign.center,
                      ),

                      heightSpace5,

                      CustomWidget().buildTextWidget(
                        title: "Join us and start riding",
                        fontSize: 16,
                        textColor: AppColors.black400,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.center,
                      ),
                      heightSpace35,
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          registrationController.selectedImage.value != null
                              ? CircleAvatar(
                                  radius: 55,
                                  backgroundColor: AppColors.green100,
                                  // backgroundImage: selectedImage != null
                                  //     ? FileImage(selectedImage!)
                                  //     : null,
                                  backgroundImage: FileImage(
                                      registrationController
                                          .selectedImage.value!),
                                  child: registrationController
                                              .selectedImage.value ==
                                          null
                                      ? const Icon(
                                          Icons.person,
                                          size: 120,
                                          color: Color(0xffF2F2F2),
                                        )
                                      : null,
                                )
                              : widget.isSocialLogin && widget.image != null
                                  ? CircleAvatar(
                            radius: 55,
                            backgroundColor: AppColors.green100,
                            backgroundImage: (widget.image?.trim().isNotEmpty ?? false)
                                ? NetworkImage(widget.image!)
                                : null,
                            child: (widget.image?.trim().isNotEmpty ?? false)
                                ? null
                                : SvgPicture.asset(Images.profileIcon),
                          )
                                  : SvgPicture.asset(Images.profileIcon),
                          Positioned(
                            bottom: -13,
                            right: 0,
                            left: 5,
                            child: GestureDetector(
                              onTap: () {
                                registrationController
                                    .showImagePickerOptions(context);
                              },
                              child: Container(
                                height: 34,
                                width: 34,
                                decoration: BoxDecoration(
                                  color: AppColors.green500,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.50),
                                      blurRadius: 3,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      heightSpace20,

                      /// Password
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomWidget().buildTextWidget(
                          title: "Full Name",
                          fontSize: 14,
                          textColor: AppColors.black300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      heightSpace8,

                      CustomWidget().buildTextFormField(
                        darkMode: true,
                        radius: 8,
                        controller: registrationController.nameController,
                        keyboardType: TextInputType.name,
                        hintText: "Enter Full Name",
                        prefixIcon: Padding(
                          padding: const EdgeInsets.all(14),
                          child: SvgPicture.asset(Images.outlinePerson),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter full name";
                          }

                          if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value.trim())) {
                            return "Name can contain only letters";
                          }

                          return null;
                        },
                      ),
                      heightSpace15,

                      /// Email
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomWidget().buildTextWidget(
                          title: "Email",
                          fontSize: 14,
                          textColor: AppColors.black300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      heightSpace8,
                      widget.isSocialLogin
                          ? CustomWidget().buildTextFormField(
                              darkMode: false,
                              radius: 8,
                              controller:
                                  registrationController.emailController,
                              readOnly: true,
                            )
                          : CustomWidget().buildTextFormField(
                              darkMode: true,
                              radius: 8,
                              // readOnly:
                              //     registrationController.isEmailVerified.value,

                              controller:
                                  registrationController.emailController,
                              keyboardType:
                                  registrationController.isEmailSelected
                                      ? TextInputType.emailAddress
                                      : TextInputType.phone,
                              hintText: "Enter Your Email",
                              onChanged: (value) {
                                if (value.trim() !=
                                    registrationController.verifiedEmail) {
                                  registrationController.isEmailVerified.value =
                                      false;
                                }
                              },
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  // registrationController.showVerificationDialog(
                                  //   context: context,
                                  //   isPhoneVerification: false,
                                  //   value: registrationController.emailController.text,
                                  // );
                                },
                                child: Padding(
                                    padding: EdgeInsets.only(
                                        top: 10, bottom: 10, right: 15),
                                    child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          final email = registrationController
                                              .emailController.text
                                              .trim();
                                          registrationController.otpController
                                              .clear();

                                          final emailRegex = RegExp(
                                            r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                          );

                                          if (email.isEmpty) {
                                            CustomWidget().showCustomToast(
                                              message:
                                                  "Please enter email first",
                                            );
                                            return;
                                          }

                                          if (!emailRegex.hasMatch(email)) {
                                            CustomWidget().showCustomToast(
                                                message:
                                                    "Please enter valid email");

                                            return;
                                          }
                                          if (!registrationController
                                              .isEmailVerified.value) {
                                            registrationController.sendEmailOTp(
                                                email, context);
                                          }
                                        },
                                        child: CustomWidget().buildTextWidget(
                                            title: registrationController
                                                    .isEmailVerified.value
                                                ? "Verified"
                                                : "Verify",
                                            textColor: registrationController
                                                    .isEmailVerified.value
                                                ? AppColors.green500
                                                : AppColors.yellow700,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600))),
                              ),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(14),
                                child: SvgPicture.asset(
                                  registrationController.isEmailSelected
                                      ? Images.messageIcon
                                      : Images.phoneIcon,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Please enter email";
                                }

                                if (!RegExp(r'^[\x00-\x7F]+$')
                                    .hasMatch(value)) {
                                  return "Email cannot contain special unicode characters";
                                }

                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );

                                if (!emailRegex.hasMatch(value.trim())) {
                                  return "Please enter valid email";
                                }

                                return null;
                              },
                            ),

                      heightSpace15,
                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomWidget().buildTextWidget(
                          title: "Phone Number",
                          fontSize: 14,
                          textColor: AppColors.black300,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      heightSpace8,
                      // widget.isSocialLogin && registrationController.phoneController.text.isNotEmpty?
                      // CustomWidget().buildTextFormField(darkMode: false,radius: 8,
                      //   controller:  registrationController.phoneController,
                      //   readOnly: true,
                      // ):

                      Obx(
                        () =>  CustomWidget().buildPhoneField(
                          darkMode:
                              registrationController.isDarkMode ? true : false,
                          readOnly: registrationController.isPhoneVerified.value,

                          onChanged: (value) {
                            if (value.trim() !=
                                registrationController.verifiedPhone) {
                              registrationController.isPhoneVerified.value =
                                  false;
                            }
                          },
                          radius: 8,
                          enableCountryPicker:
                              userType != "EXPLORER" ? false : true,
                          color: const Color(0xffF5F5F5),
                          suffixIcon: GestureDetector(
                              onTap: () {
                                // registrationController.showVerificationDialog(
                                //   context: context,
                                //   isPhoneVerification: true,
                                //   value: "+1 ${registrationController.phoneController.text}",
                                // );
                              },
                              child: Padding(
                                padding: EdgeInsets.only(top: 10, bottom: 10),
                                child: GestureDetector(
                                    onTap: () {
                                      FocusScope.of(context).unfocus();
                                      registrationController.otpController
                                          .clear();
                                      final phone = registrationController
                                          .phoneController.text
                                          .trim();

                                      if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
                                        CustomWidget().showCustomToast(
                                            message:
                                                "Please enter valid phone number");
                                        return;
                                      }
                                      if (!registrationController
                                          .isPhoneVerified.value) {
                                        registrationController.sendPhoneOTp(
                                            phone, context,registrationController.countryCode.value);
                                      }
                                    },
                                    child: CustomWidget().buildTextWidget(
                                        title: registrationController
                                                .isPhoneVerified.value
                                            ? "Verified"
                                            : "Verify",
                                        textColor: registrationController
                                                .isPhoneVerified.value
                                            ? AppColors.green500
                                            : AppColors.yellow700,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              )),
                          controller: registrationController.phoneController,
                          selectedCountry: registrationController.selectedCountry,
                          hintText: "Enter Phone Number",
                          maxLength: 15,
                          validator: (value) {
                            print("Value $value");
                            print(registrationController.countryName.value);
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter phone number";
                            }
                            if (!isValidPhone(value,
                                registrationController.countryName.value==""|| registrationController.countryName.value.isEmpty?"JM":registrationController.countryName.value)) {
                              return "Enter a valid phone number";
                            }
                            // if (!RegExp(r'^\d{10}$').hasMatch(value.trim())) {
                            //   return "Phone number must be 10 digits";
                            // }

                            return null;
                          },
                          onCountryChanged: (country) {
                            registrationController.countryCode.value =
                                country.phoneCode;
                            registrationController.countryName.value =
                                country.countryCode;
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
                          //   registrationController.countryCode.value =
                          //       country.phoneCode;
                          //   print(
                          //     "Selected Country: ${country.name} (+${country.phoneCode})",
                          //   );
                          // },
                        ),
                      ),
                      heightSpace15,

                      widget.isSocialLogin
                          ? SizedBox()
                          : Column(
                              children: [
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
                                  controller:
                                      registrationController.passwordController,
                                  obscureText:
                                      !registrationController.isPasswordVisible,
                                  // keyboardType: TextInputType.name,
                                  hintText: "Enter Your Password",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: SvgPicture.asset(Images.lockIcon),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        registrationController
                                                .isPasswordVisible =
                                            !registrationController
                                                .isPasswordVisible;
                                      });
                                    },
                                    icon: Icon(
                                      registrationController.isPasswordVisible
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 19,
                                      color: Colors.black38,
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }

                                    if (value.length < 7) {
                                      return "Password must be at least 7 characters";
                                    }

                                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                      return "Password must contain one uppercase letter";
                                    }

                                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                                      return "Password must contain one number";
                                    }

                                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]')
                                        .hasMatch(value)) {
                                      return "Password must contain one special character";
                                    }

                                    return null;
                                  },
                                ),
                                heightSpace15,

                                /// Password
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: CustomWidget().buildTextWidget(
                                    title: "Confirm Password",
                                    fontSize: 14,
                                    textColor: AppColors.black300,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                heightSpace8,
                                CustomWidget().buildTextFormField(
                                  darkMode: true,
                                  radius: 8,
                                  controller: registrationController
                                      .confirmPassController,
                                  obscureText: !registrationController
                                      .isConfirmPassVisible.value,
                                  // keyboardType: TextInputType.name,
                                  hintText: "Enter Your Confirm Password",
                                  prefixIcon: Padding(
                                    padding: const EdgeInsets.all(14),
                                    child: SvgPicture.asset(Images.lockIcon),
                                  ),
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      registrationController
                                              .isConfirmPassVisible.value =
                                          !registrationController
                                              .isConfirmPassVisible.value;
                                    },
                                    icon: Icon(
                                      registrationController
                                              .isConfirmPassVisible.value
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      size: 19,
                                      color: Colors.black38,
                                    ),
                                  ),
                                ),
                                heightSpace24,
                              ],
                            ),

                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            if (widget.isSocialLogin) {
                              if (userType == "EXPLORER") {
                                if (!registrationController
                                    .isPhoneVerified.value) {
                                  CustomWidget().showCustomToast(
                                      message:
                                          "Please Verify your phone number",
                                      backgroundColor: Colors.red);
                                } else if (registrationController
                                            .selectedImage.value ==
                                        null &&
                                    userType != "EXPLORER" &&
                                    widget.image == null) {
                                  CustomWidget().showCustomToast(
                                      message: "Please upload profile picture",
                                      backgroundColor: Colors.red);
                                  return;
                                } else {
                                  registrationController.registerGoogleUser(
                                    socialUserId: widget.socialUserId,
                                    displayName: widget.fullname,
                                    email: widget.email,
                                    photoURL: widget.image,
                                    login_type: widget.socialType.toString(),
                                      countryCode: widget.countryCode
                                  );
                                }
                              } else {
                                registrationController.googleDriverRegistration(
                                    socialUserId: widget.socialUserId,
                                    displayName: widget.fullname,
                                    email: widget.email,
                                    photoURL: widget.image, login_type: widget.socialType, countryCode: widget.countryCode);
                              }
                            } else {
                              if (registrationController.selectedImage.value ==
                                      null &&
                                  userType != "EXPLORER") {
                                CustomWidget().showCustomToast(
                                    message: "Please upload profile picture",
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (!registrationController.formKey.currentState!
                                  .validate()) {
                                return;
                              }
                              if (registrationController
                                      .confirmPassController.text !=
                                  registrationController
                                      .passwordController.text) {
                                CustomWidget().showCustomToast(
                                    message:
                                        "Confirm password does not match the entered password.",
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (!registrationController
                                  .isEmailVerified.value) {
                                CustomWidget().showCustomToast(
                                    message: "Please Verify your email",
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (!registrationController
                                  .isPhoneVerified.value) {
                                CustomWidget().showCustomToast(
                                    message: "Please Verify your phone number",
                                    backgroundColor: Colors.red);
                                return;
                              }
                              if (userType == "EXPLORER") {
                                registrationController.registerUser(loginType: widget.socialType,
                                  countryCode: "+${registrationController.countryCode.value.isEmpty?"1":registrationController.countryCode.value}"
                                );
                                // CustomWidget().showCustomToast(message: "Login Screen Redirections");
                              } else {
                                registrationController.driverRegistration(login_type: "normal",  countryCode: "+${registrationController.countryCode.value.isEmpty?"1":
                                registrationController.countryCode.value}" );
                              }
                            }

                            // Call Login API
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green500,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: CustomWidget().buildTextWidget(
                            title: "Signup",
                            textColor: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      heightSpace24,
                      Column(
                        children: [
                          CustomWidget().buildTextWidget(
                              title: "By signing up, you agree to our",
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Get.to(TermsAndConditionsScreen());
                                },
                                child: CustomWidget().buildTextWidget(
                                    title: "Terms of Service",
                                    textColor: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                              widthSpace5,
                              CustomWidget().buildTextWidget(
                                title: "and",
                                textColor: AppColors.black400,
                                fontWeight: FontWeight.w700,
                              ),
                              widthSpace5,
                              GestureDetector(
                                onTap: () {
                                  Get.to(PrivacyPolicy());
                                },
                                child: CustomWidget().buildTextWidget(
                                    title: "Privacy Policy.",
                                    textColor: AppColors.green,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                      heightSpace15,

                      // Row(
                      //   children: [
                      //     const Expanded(child: Divider(color: Colors.black12,)),
                      //     widthSpace15,
                      //     CustomWidget().buildTextWidget(
                      //       title: "Or",
                      //       fontSize: 14,
                      //       textColor: Colors.black,
                      //     ),
                      //     widthSpace15,
                      //     const Expanded(child: Divider(color: Colors.black12)),
                      //   ],
                      // ),

                      // heightSpace15,

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CustomWidget().buildTextWidget(
                              title: "Already have an account? ",
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                          GestureDetector(
                            onTap: () {
                              Get.to(LoginScreen());
                            },
                            child: CustomWidget().buildTextWidget(
                                title: "Login",
                                textColor: AppColors.green500,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          )
                        ],
                      ),
                    ],
                  ),
                  if (registrationController.isLoading.value)
                    Positioned.fill(
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.green500,
                        ),
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
  bool isValidPhone(String number, String isoCode) {
    try {
      print("Number: $number");
      print("ISO Code: $isoCode");
      final phone = PhoneNumber.parse(
        number,
        destinationCountry: IsoCode.values.byName(isoCode),
      );

      return phone.isValid();
    } catch (_) {
      return false;
    }
  }
  Widget _socialButton({
    IconData? icon,
    String? image,
    required String title,
  }) {
    return Container(
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
          if (icon != null)
            Icon(
              icon,
              color: Colors.black,
            ),
          if (image != null)
            Image.asset(
              image,
              height: 22,
            ),
          widthSpace8,
          CustomWidget().buildTextWidget(
            title: title,
            fontSize: 14,
            textColor: Colors.black,
          ),
        ],
      ),
    );
  }
}
