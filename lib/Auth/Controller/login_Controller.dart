import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:Jam_Rock_Destinations/Auth/Login_View.dart';
import 'package:Jam_Rock_Destinations/Auth/createPassword.dart';
import 'package:Jam_Rock_Destinations/Auth/registration_View.dart';
import 'package:Jam_Rock_Destinations/Customer/customer_bottom_navigation.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';
import 'package:country_picker/country_picker.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
  final countryName = "JM".obs;

  Future<void> getFirebaseToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Request permission for iOS
    await messaging.requestPermission();

    // Get FCM token
    String? token =await messaging.getToken();

    print("✅ FCM Token: $token");
  }
  Future<void> socialLogin({
    required String socialUserId,
    required String displayName,
    required String email,
    required String photoURL,
    required String login_type,
  })
  async {
    try
    {
      isLoading.value=true;
      String? token;
      try {
        // token = "fcm_token_here";
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        token = "";
      }
      final deviceData = await getDeviceInfo();
      final googleData={
        "name": displayName,
        "email": email,
        "photo_url":photoURL,
      };
      final requestData = {
        "login_type": login_type, // normal,facebook,google,apple
        "social_user_id": socialUserId,
        "country_code":"+${countryCode.value.isEmpty?"1":countryCode.value}",
        "user_login":email, // email and phone
        "user_type": userType == "EXPLORER" ? "customer" : "driver",
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token":token,
        "social_json" : jsonEncode(googleData["social_json"]),
      };
      log("requestData $requestData");
      var response = await ApiProvider().postRequest1(
          apiUrl: AppConstants.login,
          data: requestData
      );
      print("requested data from login api $requestData");
      print("response $response");

      if (response['success'] == true)
      {
        log("response after success login $response");
        await userBox.put("token", response['data']['access_token'].toString());
        await userBox.put("user_id", response['data']["user"]["id"].toString());
        await userBox.put("user_type", response['data']["user"]["user_type"].toString());
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
        print("Response !! $response");
        if(response["error_type"]=="social_user_not_found")
          {
            Get.to(RegistrationView(email: email,fullname: displayName,isSocialLogin: true,image: photoURL,
            socialUserId: socialUserId,socialType: login_type,countryCode:"+${countryCode.value.isEmpty?"1":countryCode.value}" ,));
          }
        else
          {
            final errorMessage = response['message'];
            CustomWidget().showCustomToast(
              message: errorMessage,
              backgroundColor: Colors.red,
            );
          }
        // if (response['message'] != null &&
        //     response['message'].toString().isNotEmpty) {
        //   errorMessage = response['message'].toString();
        // } else if (response['errors'] != null &&
        //     response['errors'] is Map &&
        //     response['errors'].isNotEmpty) {
        //
        //   final firstKey = response['errors'].keys.first;
        //   final errorValue = response['errors'][firstKey];
        //
        //   if (errorValue is List && errorValue.isNotEmpty) {
        //     errorMessage = errorValue.first.toString();
        //   } else {
        //     errorMessage = errorValue.toString();
        //   }
        // }


        isLoading.value=false;
      }
    }

    catch(e)
    {
      print("socialLogin catch $e");
      isLoading.value=false;
    }
    finally{
      isLoading.value=false;
    }
  }


  Future<void> signInWithApple() async {
    isLoading.value = true;

    try {
      // Request Apple ID credential
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      print("User Identifier: ${appleCredential.userIdentifier}");
      print("Email: ${appleCredential.email}");
      print("Given Name: ${appleCredential.givenName}");
      print("Family Name: ${appleCredential.familyName}");
      print("Identity Token: ${appleCredential.identityToken}");
      print("Authorization Code: ${appleCredential.authorizationCode}");

      // Create Firebase credential
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken,
        accessToken: appleCredential.authorizationCode,
      );

      // Sign in to Firebase
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(oauthCredential);

      final User? user = userCredential.user;

      if (user != null) {
        print("Firebase UID: ${user.uid}");
        print("Display Name: ${user.displayName}");
        print("Email: ${user.email}");
        print("Photo URL: ${user.photoURL}");

        await socialLogin(
          socialUserId: user.uid,
          displayName: user.displayName ??
              "${appleCredential.givenName ?? ""} ${appleCredential.familyName ?? ""}"
                  .trim(),
          email: user.email ?? appleCredential.email ?? "",
          photoURL: user.photoURL ?? "",
          login_type: 'apple',
        );
      } else {
        print("Firebase user is null.");
      }
    } on SignInWithAppleAuthorizationException catch (e) {
      print("Apple Sign-In Authorization Error: ${e.code}");
      print("Message: ${e.message}");
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");
      print("Message: ${e.message}");
    } catch (e) {
      print("Apple Sign-In Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();

      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      final user = userCredential.user;

      print("All Details: ${user}");
      print("UID: ${user?.uid}");
      print("Name: ${user?.displayName}");
      print("Email: ${user?.email}");
      print("Photo: ${user?.photoURL}");

      final idToken = await user?.getIdToken();
      print("Firebase Token: $idToken");
      if (user != null) {
        print("User Details -- $user");

        // Only update controllers if widget is still mounted

          // try {
          //   emailController.text = user.email ?? '';
          //   // fullNameController.text = user.displayName ?? '';
          //   // socialUserIdController.text = user.uid;
          // } catch (e) {
          //   print("Controller error: $e");
          // }
          //

        try {
          // await SharedPreferencesUtil.setValue("isGoogleLogin", true);
          // selectLoginTypeGoogle(true);
          // selectLoginTypeApple.value=false;
          await socialLogin(socialUserId: user.uid,
              displayName: user.displayName.toString(),
              email: user.email.toString(),
              photoURL: user.photoURL.toString(), login_type: 'google');

        } catch (e) {
          print("Registration error: ${e.toString()}");
          // CustomWidget().handleApiError(e);
        } finally {
          isLoading.value = false;
        }
        // await googleSignIn.signOut();
      } else {
        print("Firebase user is null.");
      }

      return userCredential;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }
  Future<void> loginWithGoogle() async {
    UserCredential? userCredential = await signInWithGoogle();

    if (userCredential == null) {
      print("Login cancelled");
      return;
    }

    User? user = userCredential.user;

    print("UID: ${user?.uid}");
    print("Name: ${user?.displayName}");
    print("Email: ${user?.email}");
    print("Photo: ${user?.photoURL}");

    final idToken = await user?.getIdToken();

    print("Firebase ID Token: $idToken");

    // Send to backend
    Map<String, dynamic> payload = {
      "name": user?.displayName,
      "email": user?.email,
      "firebase_uid": user?.uid,
      "id_token": idToken,
      "profile_image": user?.photoURL,
    };

    print(payload);
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
  Future<void> login(String userLogin ,String password,final countryCode)
  async {
    try
    {
      isLoading.value=true;
      String? token;
      try {
        // token = "fcm_token_here";
        token = await FirebaseMessaging.instance.getToken();
      } catch (e) {
        log("❌ Firebase Token Error: $e");
        token = "";
      }
      final deviceData = await getDeviceInfo();
      final requestData = {
        "login_type": "normal", // normal,facebook,google,apple
        "social_user_id": "",
        "country_code":countryCode,
        "user_login":userLogin, // email and phone
        "user_type": userType == "EXPLORER" ? "customer" : "driver",
        "password": passwordController.text,
        "platform": Platform.isAndroid ? "android" : "ios",
        "device_id": deviceData["device_id"],
        "device_json": jsonEncode(deviceData["device_json"]),
        "device_token":token
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
        await userBox.put("user_id", response['data']["user"]["id"].toString());
        await userBox.put("user_type", response['data']["user"]["user_type"].toString());

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
      print(" catch!! $e");
      isLoading.value=false;
    }
    finally{
      isLoading.value=false;
    }
  }

  Future<void> forgotStep1({
    required String contactValue,
    type,
    userType,
    final countryCode
  }) async {
    try {
      isLoading.value = true;
      var body = {
        "contact": contactValue,
        "type": type,
        "user_type": userType == 'EXPLORER' || userType == 'customer'
            ? "customer"
            : "driver",

        if (type == "phone")
          "country_code": "${countryCode}" // in case of type phone
      };
      print("Body $body");
      var response = await ApiProvider().postRequest1(
          apiUrl: AppConstants.forgotPasswordStep1,
          // data: {
          //     "contact" : typeValue,
          //      // "email": "john.doe@yopmail.com"
          // },

          data: body);

      print(body);

      if (response['success'] == true) {
        print("response after forgot $response");
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );
        Get.to(MailVerificationScreen(
          isForgotScreen: true,
          signupType: isEmailSelected.value ? "email" : "phone",
          emailorphone: isEmailSelected.value
              ? forgotEmailController.text
              : forgotPhoneController.text,
          countryCode: countryCode,
        ));
      } else {
        ApiProvider().showErrorFromResponse(response);
        isLoading.value = false;
      }
    } catch (e) {
      isLoading.value = false;
      print(e);
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> verifyEmailOTp(
      String email_or_phone,
      String otp,
      BuildContext context,
      final countryCode,
      String type
      ) async {
    try {
      isLoading.value = true;
      var body = {
        "contact": countryCode+email_or_phone,
        "otp": otp,
        // "country_code":countryCode
      };
      print("body = $body");
      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.forgotPasswordStep2,
        data: body
      );

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'],
          backgroundColor: AppColors.green500,
        );
        Get.to(CreateNewPasswordScreen(email: email_or_phone,token: response["data"]["token"],
          type: type,
          countryCode: countryCode,
        ));
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
      String email_or_phone,
      String password,
      String confirmPassword,
      BuildContext context,
      String token,
      String type
      ) async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.forgotPasswordStep3,
        data: {
          "token" : token.toString(),
          "contact": email_or_phone,
          "password" : password,
          "confirmed_password" : confirmPassword,
          "type":type
        },
      );

      if (response['success'] == true) {
        Get.back();
        showPasswordResetSuccessDialog(context);
        print("response $response");
        isLoading.value = false;
      } else {
        // CustomWidget().showCustomToast(
        //   message: response['message'] ?? "Something went wrong",
        //   backgroundColor: Colors.red,
        // );
        ApiProvider().showErrorFromResponse(response);
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