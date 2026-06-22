import 'package:Jam_Rock_Destinations/Common/PrivacyPolicy.dart';
import 'package:Jam_Rock_Destinations/Common/TermsAndConditions.dart';
import 'package:Jam_Rock_Destinations/Common/faq_Screen.dart';
import 'package:Jam_Rock_Destinations/Common/userProfile.dart';
import 'package:Jam_Rock_Destinations/Common/wallet/wallet.dart';
import 'package:Jam_Rock_Destinations/Driver/KYC_Screen.dart';
import 'package:Jam_Rock_Destinations/Driver/Vehicle_Management.dart';
import 'package:Jam_Rock_Destinations/Utils/app_const.dart';

import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../Utils/app_colors.dart';
import '../Utils/custom_widget.dart';
import 'DelectAccount.dart';
import 'ProfileController.dart';
import 'membership/Membership.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  ProfileController profileController = Get.put(ProfileController());
  @override
  void initState() {
    profileController.getUserProfile();
    print(userType);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => profileController.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  children: [
                    _buildHeader(),
                    const Divider(height: 1),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          GestureDetector(
                            onTap: () {
                              profileController.hasChanges.value=false;
                              profileController.selectedImage.value=null;
                              Get.to(ProfileScreen());
                            },
                            child: Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: AppColors.offWhite,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  profileController
                                      .getProfileData["profile_image_url"]==null?
                                CircleAvatar(
                                radius: 28,
                                backgroundColor: Colors.transparent,
                                child: SvgPicture.asset(Images.personLogo),):
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.transparent,
                                    child: ClipOval(
                                      child: Image.network(
                                        profileController
                                            .getProfileData["profile_image_url"]
                                            .toString(),
                                        width: 56,
                                        height: 56,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomWidget().buildTextWidget(
                                        title: profileController
                                            .getProfileData["name"]
                                            .toString(),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        textColor: AppColors.blackColor,
                                      ),
                                      const SizedBox(height: 2),
                                      CustomWidget().buildTextWidget(
                                        title: profileController
                                            .getProfileData["email"]
                                            .toString(),
                                        fontSize: 13,
                                        textColor: AppColors.black200,
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                      visible:
                                          userType != "EXPLORER" ? true : false,
                                      child: Spacer()),
                                  Visibility(
                                    visible:
                                        userType != "EXPLORER" ? true : false,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        SvgPicture.asset(Images.crownIcon),
                                        const SizedBox(height: 2),
                                        Container(
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              color: AppColors.whiteColor),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(Images.starIcon),
                                              widthSpace3,
                                              CustomWidget().buildTextWidget(
                                                title: "4.3",
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                textColor: AppColors.black400,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _settingTile(
                            image: Images.walletIcon,
                            title: "Wallet",
                            onTap: () {
                              Get.to(WalletScreen());
                            },
                          ),
                          Visibility(
                            visible: userType != "EXPLORER" ? true : false,
                            child: _settingTile(
                              image: Images.vmIcon,
                              title: "Vehicle Management",
                              onTap: () {
                                Get.to(VehicleDetailsView());
                              },
                            ),
                          ),
                          Visibility(
                            visible: userType != "EXPLORER" ? true : false,
                            child: _settingTile(
                              image: Images.kycIcon,
                              title: "KYC Documents",
                              onTap: () {
                                Get.to(KycScreen());
                              },
                            ),
                          ),
                          Visibility(
                            visible: userType != "EXPLORER" ? true : false,
                            child: _settingTile(
                              image: Images.membershipIcon,
                              title: "Membership",
                              onTap: () {
                                Get.to(MembershipScreen());
                              },
                            ),
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
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_outlined, size: 25),
              Positioned(
                // right: 10,
                bottom: 8,
                // top: 4,
                child: Container(
                  // height: 8,
                  // width: 8,
                  padding: EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: CustomWidget().buildTextWidget(
                      title: "2",
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.whiteColor,
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Visibility(
            visible: userType == "EXPLORER" ? true : false,
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.transparent,
              child:   profileController
                  .getProfileData["profile_image_url"]==null?
    CircleAvatar(
    radius: 28,
    backgroundColor: Colors.transparent,
    child: SvgPicture.asset(Images.personLogo)):ClipOval(
                child: Image.network(
                  profileController.getProfileData["profile_image_url"]
                      .toString(),
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
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
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Container(
                  padding: const EdgeInsets.all(8),
                  width: 36,
                  height: 36,
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
                  )),
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
                SvgPicture.asset(
                  Images.logout,
                  height: 90,
                  width: 90,
                ),

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
                          //  padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 10),
                          padding: EdgeInsets.all(10),
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
                    Obx(
                      () =>  Expanded(
                        child: InkWell(
                          onTap: () async {
                            profileController.Logout(context);
                          },
                          child: Container(
                            // padding: EdgeInsetsGeometry.symmetric(horizontal: 10,vertical: 10),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF87171),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: CustomWidget().buildTextWidget(
                                title: profileController.isLoading.value?"Loading...":"Logout",
                                fontSize: 16,
                                textColor: Colors.white,
                                fontWeight: FontWeight.w500,
                              ),
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
