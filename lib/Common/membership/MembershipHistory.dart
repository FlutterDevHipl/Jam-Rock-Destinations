import 'package:Jam_Rock_Destinations/Common/ProfileController/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Utils/app_images.dart';

class MembershipHistoryScreen extends StatefulWidget {
  const MembershipHistoryScreen({super.key});

  @override
  State<MembershipHistoryScreen> createState() =>
      _MembershipHistoryScreenState();
}

class _MembershipHistoryScreenState extends State<MembershipHistoryScreen> {
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
            title: "History",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  children: [
                    heightSpace20, // Premium Plan
                    _buildPlanCard(context,
                        title: 'PREMIUM',
                        price: '19.99',
                        isActive: true,
                        buttonText: 'Cancel Plan',
                        buttonColor: AppColors.redColor400,
                        onButtonTap: () {},
                        icon: Images.crownIcon),
                    heightSpace20,

                    Expanded(
                      child: ListView.builder(
                        itemCount: 5,
                        itemBuilder: (context, index) {
                          return _buildHistoryList(context,
                              title: 'PREMIUM',
                              price: '19.99',
                              isActive: true,
                              buttonText: 'Cancel Plan',
                              buttonColor: AppColors.redColor400,
                              onButtonTap: () {},
                              icon: Images.crownIcon);
                        },
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(BuildContext context,
      {required String title,
      required String price,
      required bool isActive,
      required String buttonText,
      required Color buttonColor,
      required VoidCallback onButtonTap,
      // IconData icon = Icons.crown,
      required String icon}) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 32, height: 32),
              const Spacer(),
              if (isActive)
                Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
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
              Spacer(),
              SvgPicture.asset(Images.clock),
              widthSpace3,
              CustomWidget().buildTextWidget(
                  title: '25 May 2025',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black300),
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
        ],
      ),
    );
  }

  Widget _buildHistoryList(BuildContext context,
      {required String title,
      required String price,
      required bool isActive,
      required String buttonText,
      required Color buttonColor,
      required VoidCallback onButtonTap,
      // IconData icon = Icons.crown,
      required String icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SvgPicture.asset(icon, width: 18, height: 18),
              const Spacer(),
              CustomWidget().buildTextWidget(
                  title: "Expired",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.redColor400),
            ],
          ),
          heightSpace10,
          CustomWidget().buildTextWidget(
              title: title,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              textColor: AppColors.black500),
          const SizedBox(height: 8),
          Row(
            children: [
              CustomWidget().buildTextWidget(
                  title: '\$$price ',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.green500),
              CustomWidget().buildTextWidget(
                  title: '/per month ',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black500),
              Spacer(),
              SvgPicture.asset(Images.clock),
              widthSpace3,
              CustomWidget().buildTextWidget(
                  title: '25 May to 25 June 2025',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black300),
            ],
          ),
         
         Divider(color: AppColors.black50,),
          heightSpace10,
        ],
      ),
    );
  }
}
