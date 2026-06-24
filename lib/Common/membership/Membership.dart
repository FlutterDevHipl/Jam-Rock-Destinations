import 'package:Jam_Rock_Destinations/Common/Controller/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Common/membership/MembershipHistory.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Utils/app_images.dart';

class MembershipScreen extends StatefulWidget {
  const MembershipScreen({super.key});

  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        title: CustomWidget().buildTextWidget(
            title: "Membership",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 20),
        actions: [
          GestureDetector(
            onTap: () {
              Get.to(MembershipHistoryScreen());
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: SvgPicture.asset(Images.history),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      heightSpace20, // Premium Plan
                      _buildPlanCard(context,
                          title: 'PREMIUM',
                          price: '19.99',
                          isActive: true,
                          features: [
                            'Priority listing in search',
                            'More ride offers per day',
                            'Higher earning potential',
                            'Full earnings breakdown',
                            'Dedicated support queue',
                          ],
                          buttonText: 'Cancel Plan',
                          buttonColor: AppColors.redColor400,
                          onButtonTap: () {},
                          icon: Images.crownIcon),
                      heightSpace20,
                      // Regular Plan
                      _buildPlanCard(context,
                          title: 'REGULAR',
                          price: '9.99',
                          isActive: false,
                          features: [
                            'Accept all ride requests',
                            'Basic earnings dashboard',
                            'Standard queue position',
                            'Priority listing',
                          ],
                          buttonText: 'Start with Regular',
                          buttonColor: AppColors.green500,
                          onButtonTap: () {},
                          icon: Images.starOutline),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      {required String title,
      required String price,
      required bool isActive,
      required List<String> features,
      required String buttonText,
      required Color buttonColor,
      required VoidCallback onButtonTap,
      // IconData icon = Icons.crown,
      required String icon}) {
    return Card(
      elevation: 2,
      color: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Icon(icon, color: Colors.amber, size: 28),
                SvgPicture.asset(icon, width: 32, height: 32),

                // Text(
                //   title,
                //   style: const TextStyle(
                //       fontSize: 22, fontWeight: FontWeight.bold),
                // ),
                const Spacer(),
                if (isActive)
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                          color: AppColors.green50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.green500)),
                      child: CustomWidget().buildTextWidget(
                          title: "Active",
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          textColor: AppColors.green500)),
              ],
            ),
            heightSpace10,
            CustomWidget().buildTextWidget(
                title: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.black500),
            const SizedBox(height: 8),
            Row(
              children: [
                CustomWidget().buildTextWidget(
                    title: '\$$price ',
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.green500),
                CustomWidget().buildTextWidget(
                    title: '/per month ',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black500),
              ],
            ),

            heightSpace15,

            // Action Button
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onButtonTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: buttonColor,
                  side: BorderSide(color: buttonColor),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: CustomWidget().buildTextWidget(
                    title: buttonText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: buttonColor),
              ),
            ),

            const SizedBox(height: 20),

            // Features
            ...features.map((feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      SvgPicture.asset(Images.check_circle),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CustomWidget().buildTextWidget(
                              title: feature,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              textColor: AppColors.black500)),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
