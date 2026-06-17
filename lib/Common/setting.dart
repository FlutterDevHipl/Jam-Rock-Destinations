import 'package:Jam_Rock_Destinations/Common/PrivacyPolicy.dart';
import 'package:Jam_Rock_Destinations/Common/TermAndCondition.dart';
import 'package:Jam_Rock_Destinations/Common/deleteAccount.dart';
import 'package:Jam_Rock_Destinations/Common/faq_Screen.dart';
import 'package:Jam_Rock_Destinations/Common/profile_Controller.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Utils/app_colors.dart';
import '../Utils/custom_widget.dart';


class SettingsScreen extends StatefulWidget {
  const  SettingsScreen({super.key});

   @override
   State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    profileController.getUserProfile();
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: AppColors.black50,
      body: SafeArea(
        child: Obx(
          () =>
              profileController.isLoading.value?
                  CircularProgressIndicator(color: AppColors.green500):
              Column(
            children: [
              _buildHeader(),

              const Divider(height: 1),

              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        child: Image.network(
                          profileController.getProfileData["profile_image_url"].toString(),
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomWidget().buildTextWidget(
                          title: profileController.getProfileData["name"].toString(),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          textColor: AppColors.blackColor,
                        ),

                        const SizedBox(height: 2),

                        CustomWidget().buildTextWidget(
                          title: profileController.getProfileData["email"].toString(),
                          fontSize: 13,
                          textColor: AppColors.black200,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

                    const SizedBox(height: 16),

                    _settingTile(
                      image: Images.walletIcon,
                      title: "Wallet",
                      onTap: () {},
                    ),

                    _settingTile(
                    image: Images.raiseTicketIcon,
                      title: "Raise Ticket",
                      onTap: () {},
                    ),

                    _settingTile(
                      image: Images.faqIcon,
                      title: "FAQs",
                      onTap: () {
                        Get.to(FAQScreen());
                      },
                    ),

                    _settingTile(
                      image: Images.termCondition,
                      title: "Terms & Conditions",
                      onTap: () {
                        Get.to(TermsAndConditionsScreen());
                      },
                    ),

                    _settingTile(
                      image: Images.privacyIcon,
                      title: "Privacy Policy",
                      onTap: () {
                        Get.to(PrivacyPolicy());
                      },
                    ),

                    _settingTile(
                      image: Images.deleteIcon,
                      title: "Delete Account",
                      onTap: () {
                        Get.to(DeleteAccountScreen());
                      },
                    ),

                    const SizedBox(height: 8),

                    _logoutTile(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomWidget().buildTextWidget(
              title: "Settings",
              fontSize: 28,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500,
            ),
          ),

          Stack(
            children: [
              const Icon(Icons.notifications_outlined, size: 25),

              Positioned(
                right: 2,
                top: 2,
                child: Container(
                  height: 8,
                  width: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(width: 12),

          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.transparent,
            child: ClipOval(
              child: Image.network(
                profileController.getProfileData["profile_image_url"].toString(),
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget _settingTile({
  required String image,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.offWhite,
            borderRadius: BorderRadius.circular(12),

          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF101828).withOpacity(0.1),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                      spreadRadius: -2,
                    ),
                    BoxShadow(
                      color: const Color(0xFF101828).withOpacity(0.1),
                      offset: const Offset(0, 4),
                      blurRadius: 6,
                      spreadRadius: -1,
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  image,
                  width: 20,
                  height: 20,
                )
              ),

              const SizedBox(width: 12),

              Expanded(
                child: CustomWidget().buildTextWidget(
                  title: title,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.blackColor,
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: AppColors.green500,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logoutTile() {
    return GestureDetector(
      onTap: () {
        showLogoutDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.offWhite,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffFFEAEA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.logout,
                color: Colors.red,
              ),
            ),

            const SizedBox(width: 12),

            CustomWidget().buildTextWidget(
              title: "Logout",
              fontSize: 15,
              fontWeight: FontWeight.w500,
              textColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 30,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// Logout Icon
                SvgPicture.asset(Images.logout,height: 90,width: 90,),

                const SizedBox(height: 24),

                CustomWidget().buildTextWidget(
                  title: "Are you sure you\nwant to Logout?",
                  fontSize: 18,
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
                         padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.black200,
                            ),
                          ),
                          child: Center(
                            child: CustomWidget().buildTextWidget(
                              title: "Cancel",
                              fontSize: 16,
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
                          profileController.Logout(context);
                        },
                        child: Container(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF87171),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child:
                            profileController.isLogout.value?CircularProgressIndicator(color: Colors.white,):
                            CustomWidget().buildTextWidget(
                              title: "Logout",
                              fontSize: 16,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w500,
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
        );
      },
    );
  }
}