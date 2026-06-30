import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:Jam_Rock_Destinations/Customer/customer_bottom_navigation.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';

import '../../Services/api_provider.dart';
import '../../Utils/api_url.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/storage.dart';
import '../profileSetup1.dart';

class RegistrationController extends GetxController {
  bool isEmailSelected = true;
  bool isPasswordVisible = false;
  final isConfirmPassVisible = false.obs;
  final selectedImage = Rxn<File>();

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

  // Future<void> pickImage(ImageSource camera) async {
  //   final XFile? image = await ImagePicker().pickImage(
  //     source: ImageSource.gallery,
  //     imageQuality: 80,
  //   );
  //
  //   if (image != null) {
  //
  //       selectedImage.value = File(image.path);
  //   }
  // }
  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );

    if (image == null) return;

    // Crop Image
    final croppedPath = await CustomWidget().cropImage(image.path);
    if (croppedPath == null) return;

    // Compress Image
    final compressedFile =
    await CustomWidget().compressImage(File(croppedPath));

    // Check file size (5 MB)
    const int maxSizeInBytes = 5 * 1024 * 1024;

    if (await compressedFile.length() > maxSizeInBytes) {
      CustomWidget().showCustomToast(
        message: "Image size should not exceed 5 MB",
        backgroundColor: Colors.red,
      );
      return;
    }

    selectedImage.value = compressedFile;
  }
  // Future<void> pickImage(ImageSource source) async {
  //   final XFile? image = await ImagePicker().pickImage(
  //     source: source,
  //     imageQuality: 80,
  //   );
  //
  //   if (image == null) return;
  //
  //   // Crop Image
  //   final croppedPath = await CustomWidget().cropImage(image.path);
  //   if (croppedPath == null) return;
  //
  //   // Compress Image
  //   final compressedFile =
  //       await CustomWidget().compressImage(File(croppedPath));
  //
  //   selectedImage.value = compressedFile;
  // }

  bool isDarkMode = Get.isDarkMode;
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  String verifiedEmail = "";
  String verifiedPhone = "";
  final isEmailVerified = false.obs;
  final isPhoneVerified = false.obs;

  final otpError = ''.obs;
  final countryCode = ''.obs;
  final countryName = 'JM'.obs;

  bool validateOtp() {
    if (otpController.text.length != 4) {
      otpError.value = "Please enter a valid 4-digit OTP";
      return false;
    }

    otpError.value = '';
    return true;
  }

  Future<void> getFirebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    await messaging.requestPermission();

    // Get FCM token
    String? token = await messaging.getToken();

    print("✅ FCM Token: $token");
  }

  final Rx<Country?> selectedCountry = Rx<Country?>(
    Country(
      phoneCode: "1",
      countryCode: "JM",
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
  String maskPhoneNumber(String phone) {
    if (phone.length < 6) return phone;

    String countryCode = phone.substring(0, 2); // +1
    String last2 = phone.substring(phone.length - 2);

    return '$countryCode X XXX XX$last2';
  }

  RxBool isOtpDialogOpen = false.obs;
  void showVerificationDialog({
    required BuildContext context,
    required bool isPhoneVerification,
    required String value,
    VoidCallback? onSubmit,
    VoidCallback? onResend,
    VoidCallback? onChange,
  }) {
    final otpControllers = List.generate(
      4,
      (_) => TextEditingController(),
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.65),
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 20,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Close Button
                Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      isOtpDialogOpen.value = false;
                      Get.back();
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: 22,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                /// Title
                CustomWidget().buildTextWidget(
                  title: isPhoneVerification
                      ? "Phone Number Verification"
                      : "Mail Verification",
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black500,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 8),

                /// Description
                CustomWidget().buildTextWidget(
                  title: "A 4-digit code has been sent to",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black400,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 2),
                isPhoneVerification
                    ? CustomWidget().buildTextWidget(
                        title:
                            "+${countryCode.value.isEmpty ? "1" : countryCode.value} ${maskPhoneNumber(value)}",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: const Color(0xffC5A227),
                        textAlign: TextAlign.center,
                      )
                    : CustomWidget().buildTextWidget(
                        title: value,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: const Color(0xffC5A227),
                        textAlign: TextAlign.center,
                      ),

                const SizedBox(height: 28),

                /// OTP Fields

                Column(
                  children: [
                    Pinput(
                      controller: otpController,
                      length: 4,
                      keyboardType: TextInputType.number,
                      onChanged: (_) {
                        otpError.value = '';
                      },
                      defaultPinTheme: PinTheme(
                        width: 58,
                        height: 58,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffF4F4F4),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => otpError.value.isNotEmpty
                          ? Text(
                              otpError.value,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                /// Resend Code
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomWidget().buildTextWidget(
                      title: "Didn't receive a code? ",
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      textColor: const Color(0xff666666),
                    ),
                    GestureDetector(
                      onTap: () async {
                        if (isPhoneVerification == true) {
                          await sendPhoneOTp(
                              phoneController.text, context, countryCode.value);
                          // CustomWidget().showCustomToast(message: "OTP has been resent successfully.");
                        } else {
                          await sendEmailOTp(
                            emailController.text,
                            context,
                          );
                          // CustomWidget().showCustomToast(message: "OTP has been resent successfully.");
                        }
                      },
                      child: CustomWidget().buildTextWidget(
                        title: "Resend Code",
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        textColor: const Color(0xff2F8F46),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                /// Submit Button
                Obx(
                  () => CustomWidget().buildMaterialBtn(
                    text: isLoading.value ? "Loading..." : "Submit",
                    color: AppColors.green500,
                    radius: 8,
                    fontSize: 16,
                    onPressed: () async {
                      if (otpController.text.length != 4) {
                        otpError.value = "Please enter a valid 4-digit OTP";
                        return;
                      }
                      if (isPhoneVerification == true) {
                        await verifyPhoneOTp(
                            phoneController.text, otpController.text, context);
                      } else {
                        await verifyEmailOTp(
                          emailController.text,
                          otpController.text,
                          context,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Change Email/Phone
                GestureDetector(
                  onTap: () {
                    isOtpDialogOpen.value = false;
                    Get.back();
                  },
                  child: CustomWidget().buildTextWidget(
                    title: isPhoneVerification
                        ? "Change Phone Number?"
                        : "Change Email Address?",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: const Color(0xff2F8F46),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> sendEmailOTp(
    String email,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.sendEmailOTP,
        data: {
          "email": email,
        },
      );

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: "OTP has been sent",
          backgroundColor: AppColors.green500,
        );

        otpController.clear();
        if (!isOtpDialogOpen.value) {
          isOtpDialogOpen.value = true;

          showVerificationDialog(
            context: context,
            isPhoneVerification: false,
            value: email,
          );
        }
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

  Future<void> sendPhoneOTp(
    String phone,
    BuildContext context,
    String countryCode,
  ) async {
    try {
      isLoading.value = true;
      if (countryCode.isEmpty) {
        countryCode = "1";
      }
      final body = {"phone": phone, "country_code": "+${countryCode}"};
      var response = await ApiProvider()
          .postRequest1(apiUrl: AppConstants.sendPhoneOTP, data: body);

      log("phone $phone");
      log("body $body");
      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: "OTP has been sent",
          backgroundColor: AppColors.green500,
        );

        otpController.clear();

        // showVerificationDialog(
        //   context: context,
        //   isPhoneVerification: true,
        //   value: phone,
        //
        //
        // );
        if (!isOtpDialogOpen.value) {
          isOtpDialogOpen.value = true;

          showVerificationDialog(
            context: context,
            isPhoneVerification: true,
            value: phone,
          );
        }
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

  Future<void> verifyEmailOTp(
    String email,
    String otp,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.verifyEmailOTP,
        data: {
          "email": email,
          "otp": otp,
        },
      );

      print("response $response");

      if (response['success'] == true) {
        Get.back(); // Close OTP Dialog
        isEmailVerified.value = true;
        CustomWidget().showCustomToast(
          message: "Email verified successfully",
          backgroundColor: AppColors.green500,
        );
        isOtpDialogOpen.value = false;
        isEmailVerified.value = true;
        verifiedEmail = emailController.text.trim();
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

  Future<void> verifyPhoneOTp(
    String phone,
    String otp,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;
      final body = {
        "phone": phone,
        "otp": otp,
        "country_code":
            "+${countryCode.value.isEmpty ? "1" : countryCode.value}"
      };
      var response = await ApiProvider()
          .postRequest1(apiUrl: AppConstants.verifyPhoneOTP, data: body);

      print("response $response");
      print("verifyPhoneOTp body $body");

      if (response['success'] == true) {
        Get.back(); // Close OTP Dialog
        isPhoneVerified.value = true;
        CustomWidget().showCustomToast(
          message: "Phone verified successfully",
          backgroundColor: AppColors.green500,
        );
        isOtpDialogOpen.value = false;
        isPhoneVerified.value = true;
        verifiedPhone = phoneController.text.trim();
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

  Future<void> registerGoogleUser({
    required String socialUserId,
    required String displayName,
    required String email,
    required String photoURL,
    required String login_type,
    required String countryCode,
  }) async {
    try {
      isLoading.value = true;

      final deviceData = await getDeviceInfo();
      String? token;
      try {
        // token = "fcm_token_here";
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        token = "";
      }
      final googleData = {
        "name": displayName,
        "email": email,
        "photo_url": photoURL,
      };
      print("googleData ${googleData}");
      final requestData = {
        "register_type": login_type,
        "user_type": userType == "customer" ? "customer" : "driver",
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "country_code": "${countryCode}",
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token": token,
        "social_user_id": socialUserId, // Social login case
        "social_json": jsonEncode({
          "name": displayName,
          "email": email,
          "photo_url": photoURL,
        }),
      };

      var response = await ApiProvider().putRequestProfile(
        apiUrl: AppConstants.register,
        fields: requestData,
        imageKey: "profile_image",
        userImage: selectedImage,
      );

      print("registerGoogleUser Register Response: $response");

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );
        print("User id ${response['data']["user"]["id"].toString()}");
        await userBox.put("user_id", response['data']["user"]["id"].toString());
        await userBox.put("token", response['data']["access_token"].toString());
        await userBox.put(
            "user_type", response['data']["user"]["user_type"].toString());

        Get.offAll(CustomerBottomNavigation(
          index: 0,
        ));
      } else {
        String errorMessage = "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {
          final firstKey = response['errors'].keys.first;
          errorMessage = response['errors'][firstKey].first.toString();
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Register Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser({final loginType, final countryCode}) async {
    try {
      isLoading.value = true;

      final deviceData = await getDeviceInfo();
      String? token;
      try {
        // token = "fcm_token_here";
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        token = "";
      }
      final requestData = {
        "register_type": loginType,
        "user_type": userType == "customer" ? "customer" : "driver",
        "country_code": countryCode,
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "password": passwordController.text,
        "password_confirmation": confirmPassController.text,
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token": token
      };
      print("requestData = $requestData");
      var response = await ApiProvider().putRequestProfile(
        apiUrl: AppConstants.register,
        fields: requestData,
        imageKey: "profile_image",
        userImage: selectedImage,
      );

      print("Register Response: $response");

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );
        print("User id ${response['data']["user"]["id"].toString()}");
        await userBox.put("user_id", response['data']["user"]["id"].toString());
        await userBox.put("token", response['data']["access_token"].toString());
        await userBox.put(
            "user_type", response['data']["user"]["user_type"].toString());

        Get.offAll(CustomerBottomNavigation(
          index: 0,
        ));
      } else {
        String errorMessage = "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {
          final firstKey = response['errors'].keys.first;
          errorMessage = response['errors'][firstKey].first.toString();
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Register Error!!: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> googleDriverRegistration({
    required String socialUserId,
    required String displayName,
    required String email,
    required String photoURL,
    required String login_type,
    required String countryCode,
  }) async {
    try {
      isLoading.value = true;

      final deviceData = await getDeviceInfo();
      String? fcmToken;
      try {
        // token = "fcm_token_here";
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        fcmToken = "";
      }
      final googleData = {
        "name": displayName,
        "email": email,
        "photo_url": photoURL,
      };
      final requestData = {
        "register_step": 1,
        // "device_token": "fcm_token_here",
        "register_type": login_type,
        "user_type": "driver",
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "country_code": "${countryCode}",
        // "phone": "+${countryCode.value}${phoneController.text.trim()}",
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token": fcmToken,
        "social_user_id": socialUserId, // Social login case
        "social_json": jsonEncode({
          "name": displayName,
          "email": email,
          "photo_url": photoURL,
        }), // Social login case
      };

      var response = await ApiProvider().putRequestProfile(
        apiUrl: AppConstants.register,
        fields: requestData,
        imageKey: "profile_image",
        userImage: selectedImage,
      );

      print("googleDriverRegistration Register Response: $response");

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );

        print(
            "Very First api for registration token =  ${response["data"]["registration_token"]}");
        print(
            "Very First api for registration  step = ${response["data"]["next_step"]}");
        Get.to(ProfileSetupStepOneView(
          token: response["data"]["registration_token"],
          step: response["data"]["next_step"],
        ));
      } else {
        String errorMessage = "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {
          final firstKey = response['errors'].keys.first;
          errorMessage = response['errors'][firstKey].first.toString();
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Register Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> driverRegistration({
    required String login_type,
    required String countryCode,
  }) async {
    try {
      isLoading.value = true;

      final deviceData = await getDeviceInfo();
      String? fcmToken;
      try {
        // token = "fcm_token_here";
        fcmToken = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        fcmToken = "";
      }
      final requestData = {
        "register_step": 1,
        // "device_token": "fcm_token_here",
        "register_type": login_type,
        "user_type": "driver",
        "name": nameController.text.trim(),
        "email": emailController.text.trim(),
        "phone": phoneController.text.trim(),
        "country_code": "${countryCode}",
        "password": passwordController.text,
        "password_confirmation": confirmPassController.text,
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token": fcmToken
      };

      var response = await ApiProvider().putRequestProfile(
        apiUrl: AppConstants.register,
        fields: requestData,
        imageKey: "profile_image",
        userImage: selectedImage,
      );

      print("driverRegistration Register Response: $response");

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );

        print(
            "Very First api for registration token =  ${response["data"]["registration_token"]}");
        print(
            "Very First api for registration  step = ${response["data"]["next_step"]}");
        Get.to(ProfileSetupStepOneView(
          token: response["data"]["registration_token"],
          step: response["data"]["next_step"],
        ));
      } else {
        String errorMessage = "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {
          final firstKey = response['errors'].keys.first;
          errorMessage = response['errors'][firstKey].first.toString();
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Register Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

// Future<void> login(String userLogin ,String password)
// async {
//     try
//         {
//           isLoading.value=true;
//           final deviceData = await getDeviceInfo();
//
//           var response = await ApiProvider().postRequest1(
//             apiUrl: AppConstants.login,
//             data: {
//               "login_type": "normal", // normal,facebook,google,apple
//               "social_user_id": "",
//               "user_login": "+${countryCode.value}${phoneController.text.trim()}", // email and phone
//               "password": passwordController.text,
//               "platform": Platform.isAndroid ? "android" : "ios",
//               "device_id": deviceData["device_id"],
//               "device_json": jsonEncode(deviceData["device_json"]),
//             },
//           );
//
//           print("response $response");
//
//           if (response['success'] == true) {
//
//           }
//           isLoading.value=false;
//         }
//   catch(e)
//   {
//     isLoading.value=false;
//   }
//     finally{
//       isLoading.value=false;
//     }
//   }
  @override
  void dispose() {
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
