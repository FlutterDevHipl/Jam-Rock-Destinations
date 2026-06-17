import 'dart:ui';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../Utils/app_colors.dart';
import '../Utils/custom_widget.dart';
import 'ProfileController.dart';

class DeleteAccountScreen extends StatelessWidget {
  DeleteAccountScreen({super.key});
  final ProfileController  controller = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    final List<String> points = [
      "All your booking history will be lost",
      "Active bookings will be cancelled",
      "Pending refunds may be affected",
      "You will be logged out immediately",
    ];

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
          title: "Delete Account",
          fontSize: 20,
          textColor: AppColors.black500,
          fontWeight: FontWeight.w700,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      /// Illustration
                      Center(
                          child: SvgPicture.asset(Images.deleteAccount,
                            height: 250,
                            fit: BoxFit.contain,)
                      ),

                      const SizedBox(height: 32),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: CustomWidget().buildTextWidget(
                          title:
                          "This action is permanent and cannot be undone. Before you go, note that:",
                          fontSize: 18,
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      ...points.map(
                            (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(
                                  top: 7,
                                  right: 10,
                                ),
                                child: CircleAvatar(
                                  radius: 2,
                                  backgroundColor: Color(0xFF6B7280),
                                ),
                              ),
                              Expanded(
                                child:
                                CustomWidget().buildTextWidget(
                                  title: item,
                                  fontSize: 16,
                                  textColor: AppColors.black400,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Delete Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    showDeleteAccountDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF56C6C),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: CustomWidget().buildTextWidget(
                    title: "Yes, Delete Account",
                    fontSize: 16,
                    textColor: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> showDeleteAccountDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          backgroundColor: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 28,
              ),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(Images.deleteAccIcon),

                  const SizedBox(height: 28),

                  CustomWidget().buildTextWidget(
                    title: "Are you sure you want\nto Delete your Account?",
                    fontSize: 18,
                    textColor: AppColors.black500,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 32),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                color: AppColors.black400,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: CustomWidget().buildTextWidget(
                              title: "Cancel",
                              fontSize: 16,
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.deleteAccount(context);
                              /// Delete Account API Call
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffF87171),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: CustomWidget().buildTextWidget(
                              title: "Delete",
                              fontSize: 16,
                              textColor: Colors.white,
                              fontWeight: FontWeight.w600,
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