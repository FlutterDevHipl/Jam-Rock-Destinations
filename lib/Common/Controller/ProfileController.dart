import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:Jam_Rock_Destinations/Common/setting/VerificationScreen.dart';
import 'package:Jam_Rock_Destinations/Driver/driver_bottom_navigation.dart';
import 'package:Jam_Rock_Destinations/Services/api_provider.dart';
import 'package:Jam_Rock_Destinations/Utils/api_url.dart';
import 'package:Jam_Rock_Destinations/Utils/storage.dart';
import 'package:Jam_Rock_Destinations/WelcomeScreens/select_role.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../Utils/app_colors.dart';
import '../../Utils/app_images.dart';
import '../../Utils/custom_widget.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var isLogout = false.obs;
  final getProfileData = {}.obs;
  final termsPrivacy = {}.obs;
  RxBool hasChanges = false.obs;
  TextEditingController name = TextEditingController();
  TextEditingController otpController = TextEditingController();
  var faq = [].obs;
  bool isDarkMode = Get.isDarkMode;
    final box = GetStorage();
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
  final countryCode = ''.obs;
   final countryName = ''.obs;
  final selectedImage = Rxn<File>();

  @override
  void dispose() {
    name.dispose();
    otpController.dispose();
    super.dispose();
  }

  showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> editProfile() async {
    try {
      isLoading.value = true;
      print("Token ${getToken()}");
      final response = await ApiProvider().PostRequestProfile(
        apiUrl: AppConstants.editProfile,
        token: getToken(),
        imageKey: "profile_image",
        userImage: selectedImage,
        fields: {
          "name": name.text,
        },
      );

      if (response['success'] == true) {
        getUserProfile();
        print(response);
        CustomWidget().showCustomToast(
            message: response["message"], backgroundColor: AppColors.green500);
        isLoading.value = false;
        hasChanges.value = false;
        selectedImage.value = null;
      }
    } catch (e) {
      print(e);
      isLoading.value = false;
    }
  }

  void showPasswordResetSuccessDialog(BuildContext context, String value) {
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
                    title: value,
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
                        Get.offAll(DriverBottomNavigation(
                          index: 3,
                        ));
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

  Future<void> sendVerificationOTp(
    String value,
    String type,
    BuildContext context,
    final countryCode,
  ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: type == "email"
            ? AppConstants.sendEmailOTP
            : AppConstants.sendPhoneOTP,
        data: {
          type: value,
        },
      );
      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: "OTP has been sent",
          backgroundColor: AppColors.green500,
        );
        Get.to(VerificationScreen(
          signupType: type,
          emailorphone: value,
          countryCode: countryCode,
        ));
      } else {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Failed to send OTP",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTp(
    String value,
    String type,
    String otp,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
          apiUrl: type == "email"
              ? AppConstants.verifyEmailOTP
              : AppConstants.verifyPhoneOTP,
          data: {
            type: value,
            "otp": otp,
          },
          token: getToken());

      print("response $response");

      if (response['success'] == true) {
        type == "email"
            ? showPasswordResetSuccessDialog(
                context, "Email Updated Successfully!")
            : showPasswordResetSuccessDialog(
                context, "Phone Number Updated Successfully!");
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

  Future<void> getUserProfile() async {
    // try{
    //
    // }
    // catch (e){
    //   isLoading.value=false;
    // }
    // finally{
    //   isLoading.value=false;
    // }
    isLoading.value = true;
    print("Token ${getToken()}");
    final response = await ApiProvider()
        .getRequest(apiUrl: AppConstants.getProfile, token: getToken());

    if (response['success'] == true) {
      getProfileData.value = response["data"]["user"];
      print(response);
      print("getProfileData = ${getProfileData.values}");
      isLoading.value = false;
    } else {
      print("else getProfileData = ${response}");
    }
  }

  final privacyUrl = "".obs;
  final termsUrl = "".obs;

  termsPrivacyApi() async {
    try {
      isLoading.value = true;
      var response = await ApiProvider().getRequest(
        apiUrl: AppConstants.getTermsPrivacy,
      );
      if (response["success"] == true) {
        var data = response["data"];
        privacyUrl.value = data["privacy_policy"];
        termsUrl.value = data["terms_conditions"];
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

  getFAQ() async {
    try {
      isLoading.value = true;
      var response = await ApiProvider().getRequest(
        apiUrl: AppConstants.faq,
      );
      if (response["success"] == true) {
        faq.value = response["data"]["faqs"];
        isLoading.value = false;
      } else {
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
    }
  }

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

  Logout(BuildContext context) async {
    try {
      isLogout.value = true;
      final deviceData = await getDeviceInfo();
      var response = await ApiProvider()
          .postRequest1(apiUrl: AppConstants.logout, token: getToken(), data: {
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
      });
      if (response["success"] == true) {
        CustomWidget().showCustomToast(
            message: response['message'],
            backgroundColor: AppColors.greenColor);
        await userBox.clear();
        Get.offAll(() => const SelectRoleScreen());
        if (Navigator.canPop(context)) Navigator.pop(context);
        isLogout.value = false;
         box.write('seenOnboarding', true);
      } else {
        isLogout.value = false;
      }
    } catch (e) {
      isLogout.value = false;
    }
  }

  deleteAccount(BuildContext context) async {
    try {
      isLogout.value = true;
      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.deleteAccount,
        token: getToken(),
      );
      if (response["success"] == true) {
        CustomWidget().showCustomToast(
            message: response['message'],
            backgroundColor: AppColors.greenColor);
        await userBox.clear();
        Get.offAll(() => const SelectRoleScreen());
        if (Navigator.canPop(context)) Navigator.pop(context);
        isLogout.value = false;
      } else {
        isLogout.value = false;
      }
    } catch (e) {
      isLogout.value = false;
    }
  }

  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 30,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Logout Icon
                  Container(
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFE5E5),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        height: 65,
                        width: 65,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF87171),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  CustomWidget().buildTextWidget(
                    title: "Are you sure you\nwant to Logout?",
                    fontSize: 24,
                    textColor: AppColors.black500,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: AppColors.black200,
                              ),
                            ),
                            child: Center(
                              child: CustomWidget().buildTextWidget(
                                title: "Cancel",
                                fontSize: 18,
                                textColor: AppColors.black500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () async {
                            Get.back();

                            // Logout API
                          },
                          child: Container(
                            height: 58,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF87171),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: CustomWidget().buildTextWidget(
                                title: "Logout",
                                fontSize: 18,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
