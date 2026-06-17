import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Jam_Rock_Destinations/Auth/Login_View.dart';
import 'package:Jam_Rock_Destinations/Auth/createPassword.dart';
import 'package:Jam_Rock_Destinations/Customer/customer_bottom_navigation.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../Customer/home_screen.dart';
import '../../Services/api_provider.dart';
import '../../Utils/api_url.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../Utils/custom_widget.dart';
import '../../Driver/driver_bottom_navigation.dart';
import '../../Utils/storage.dart';
import '../verify_OTP.dart';

class LoginController extends GetxController
{
  final TextEditingController resetPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final otpController=TextEditingController();
  final TextEditingController forgotEmailController = TextEditingController();
  final TextEditingController forgotPhoneController = TextEditingController();
  final emailController = TextEditingController(text: "mohit@yopmail.com");
  final phoneController = TextEditingController();
  final passwordController = TextEditingController(text: "Mohit@123");
  final isLoading=false.obs;
  bool isDarkMode = Get.isDarkMode;
  final countryCode = ''.obs;
  final isEmailSelected = true.obs;

  final Rx<Country?> selectedCountry = Rx<Country?>(
    Country(
      phoneCode: "1",
      countryCode: "IN",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Jamaica",
      example: "876 XXX XXXX",
      displayName: "Jamaica",
      displayNameNoCountryCode: "Jamaica",
      e164Key: "",
    ),
  );
  Future<Map<String, dynamic>> getDeviceInfo() async {
    final deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

      return {
        "device_id": androidInfo.id,
        "device_json": {
          "brand": androidInfo.brand,
          "model": androidInfo.model,
          "device": androidInfo.device,
          "manufacturer": androidInfo.manufacturer,
          "android_version": androidInfo.version.release,
          "sdk_int": androidInfo.version.sdkInt,
        }
      };
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;

      return {
        "device_id": iosInfo.identifierForVendor ?? "",
        "device_json": {
          "name": iosInfo.name,
          "model": iosInfo.model,
          "system_name": iosInfo.systemName,
          "system_version": iosInfo.systemVersion,
        }
      };
    }

    return {};
  }
  Future<void> login(String userLogin ,String password)
  async {
    try
    {
      isLoading.value=true;
      final deviceData = await getDeviceInfo();
      final requestData = {
        "login_type": "normal", // normal,facebook,google,apple
        "social_user_id": "",
        "user_login":userLogin, // email and phone
        "user_type": userType == "EXPLORER" ? "customer" : "driver",
        "password": passwordController.text,
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
      };
      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.login,
        data: requestData
      );
      print("requested data from login api $requestData");
      print("response $response");

      if (response['success'] == true) {
        log("response after success login $response");
        await userBox.put("token", response['data']['access_token'].toString());
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );
        userType=="EXPLORER"?
        Get.offAll(CustomerBottomNavigation(index: 0,)):
        Get.offAll(DriverBottomNavigation(index: 0,));
        isLoading.value=false;
      }
      else {

        String errorMessage = "Something went wrong";

        if (response['message'] != null &&
            response['message'].toString().isNotEmpty) {
          errorMessage = response['message'].toString();
        } else if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {

          final firstKey = response['errors'].keys.first;
          final errorValue = response['errors'][firstKey];

          if (errorValue is List && errorValue.isNotEmpty) {
            errorMessage = errorValue.first.toString();
          } else {
            errorMessage = errorValue.toString();
          }
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
        isLoading.value=false;
      }
      }

    catch(e)
    {
      isLoading.value=false;
    }
    finally{
      isLoading.value=false;
    }
  }

Future<void> forgotStep1(String typeValue)
  async {
    try{
      isLoading.value=true;
      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.forgotPasswordStep1,
        data: {
            "contact" : typeValue  // "email": "john.doe@yopmail.com"
        },
      );
      print(typeValue);

          if (response['success'] == true) {
        print("response after forgot $response");
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );
        Get.to(MailVerificationScreen(
          isForgotScreen: true,
          signupType: isEmailSelected.value?"EMAIL":"PHONE",
          emailorphone: isEmailSelected.value? forgotEmailController.text : forgotPhoneController.text,
        ));
      }
          else
          {
            String errorMessage = "Registration failed";

            if (response['errors'] != null &&
                response['errors'] is Map &&
                response['errors'].isNotEmpty) {
              final firstKey = response['errors'].keys.first;
              errorMessage = response['errors'][firstKey].first.toString();
            } else if (response['message'] != null &&
                response['message'].toString().isNotEmpty) {
              errorMessage = response['message'].toString();
            }

            CustomWidget().showCustomToast(
              message: errorMessage,
              backgroundColor: Colors.red,
            );

            isLoading.value = false;
          }

    }
    catch(e)
    {
      isLoading.value=false;
      print(e);
    }
    finally
        {
          isLoading.value=false;
        }
}
  Future<void> verifyEmailOTp(
      String email_or_phone,
      String otp,
      BuildContext context,
      ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.forgotPasswordStep2,
        data: {
          "contact": email_or_phone,
          "otp": otp,
        },
      );

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'],
          backgroundColor: AppColors.green500,
        );
        Get.to(CreateNewPasswordScreen(email: email_or_phone,token: response["data"]["token"],));
        print("response $response");
        isLoading.value = false;
      } else {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Invalid OTP",
          backgroundColor: Colors.red,
        );
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> resetPassword(
      String email,
      String password,
      String confirmPassword,
      BuildContext context,
      ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.forgotPasswordStep3,
        data: {
          "token" : "eyJpdiI6Iml5VUc3SGVzaDN3N2syTEw2dTFSVEE9PSIsInZhbHVlIjoiVU9PSzE5RUI4cG9PREo4VG5TM2ZtZz09IiwibWFjIjoiMDhjOTJlZWJlNzQxODIzMWMzMWQ5M2JmODc3OTA4M2Q3MGVhNTIzZDgyYWU0ZjI2MjMzNGFiNDllNGEyYWY5NiIsInRhZyI6IiJ9",
          "contact": email,
          "password" : password,
          "confirmed_password" : confirmPassword,
        },
      );

      if (response['success'] == true) {
        Get.back();
        showPasswordResetSuccessDialog(context);
        print("response $response");
        isLoading.value = false;
      } else {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Something went wrong",
          backgroundColor: Colors.red,
        );
        isLoading.value = false;
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading.value = false;
    }
  }
  void showPasswordResetSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: Dialog(
            backgroundColor: Colors.transparent,
            elevation: 0,
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 24,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Images.tickIcon),

                  const SizedBox(height: 16),

                  CustomWidget().buildTextWidget(
                    title: "Password reset\nsuccessfully",
                    textAlign: TextAlign.center,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.appColor,
                  ),

                  const SizedBox(height: 24),

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
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: CustomWidget().buildTextWidget(
                        title: "Okay",
                        textColor: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  @override
  void dispose() {
    emailController.dispose();
    forgotEmailController.dispose();
    forgotPhoneController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}