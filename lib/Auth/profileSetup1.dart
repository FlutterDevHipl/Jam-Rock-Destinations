import 'dart:io';
import 'dart:ui';
import 'package:Jam_Rock_Destinations/Auth/Controller/Driver_Registration.dart';
import 'package:Jam_Rock_Destinations/Auth/profileSetup2.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/custom_widget.dart';

class ProfileSetupStepOneView extends  StatefulWidget{
  final token;
  final step;
   ProfileSetupStepOneView({super.key, this.token, this.step});
  @override
  State<ProfileSetupStepOneView> createState() => _ProfileSetupStepOneViewState();
}
final VehicleDetailsController vehicleDetailsController =Get.put(VehicleDetailsController());
class _ProfileSetupStepOneViewState extends State<ProfileSetupStepOneView> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(
          color: Colors.black,
        ),
        title: CustomWidget().buildTextWidget(
          title: "Profile Setup",
          fontSize: 22,
          fontWeight: FontWeight.w700,
          textColor: AppColors.blackColor,
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20, top: 10, bottom: 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffE7F4EA),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: CustomWidget().buildTextWidget(
                title: "1/2",
                fontSize: 14,
                fontWeight: FontWeight.w600,
                textColor: AppColors.green500,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.green500,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              if (vehicleDetailsController.governmentFrontImage.value == null) {
                CustomWidget().showCustomToast(
                  message: "Please Upload Government ID",
                );
                return;
              }
              else if (vehicleDetailsController.licenseFrontImage.value == null) {
                CustomWidget().showCustomToast(
                  message: "Please Upload Driving License",
                );
                return;
              }
              else if (vehicleDetailsController.crbFrontImage.value == null) {
                CustomWidget().showCustomToast(
                  message: "Please Upload CRB Document",
                );
                return;
              }
              vehicleDetailsController.driverRegistration(widget.token,widget.step);


            },
            child: CustomWidget().buildTextWidget(
              title: "Save & Next",
              textColor: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomWidget().buildTextWidget(
              title: "Upload Documents",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textColor: AppColors.blackColor,
            ),

            const SizedBox(height: 4),

            CustomWidget().buildTextWidget(
              title: "We need these to verify your identity.",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              textColor: AppColors.black400,
            ),

            const SizedBox(height: 30),

            _documentSection(
              title: "Government ID",
              frontImage: vehicleDetailsController.governmentFrontImage,
              backImage: vehicleDetailsController.governmentBackImage,
            ),

            const SizedBox(height: 20),

            _documentSection(
              title: "Driving License",
              frontImage: vehicleDetailsController.licenseFrontImage,
              backImage: vehicleDetailsController.licenseBackImage,
            ),

            const SizedBox(height: 20),

            _documentSection(
              title: "CRB (Criminal Record Background) Check ",
              frontImage: vehicleDetailsController.crbFrontImage,
              backImage: vehicleDetailsController.crbBackImage,
            ),

            const SizedBox(height: 25),

            Center(
              child: Column(
                children: [
                  CustomWidget().buildTextWidget(
                    title: "Upload clear & valid documents",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black400,
                  ),
                  CustomWidget().buildTextWidget(
                    title: "(JPG, PNG or PDF · Max 5MB)",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.green500,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _documentSection({
    required String title,
    required Rx<File?> frontImage,
    required Rx<File?> backImage,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget().buildTextWidget(
          title: title,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          textColor: AppColors.black400,
        ),

        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1,color: AppColors.black50)
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                      () => _uploadBox(
                    title: "Front",
                        image: frontImage.value,
                    onTap: () => vehicleDetailsController.pickImage(frontImage),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Obx(
                      () => _uploadBox(
                    title: "Back (Optional)",
                    image: backImage.value,
                    onTap: () => vehicleDetailsController.pickImage(backImage),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _uploadBox({
    required String title,
    required VoidCallback onTap,
    File? image,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: DottedBorder(
        color: AppColors.green500,
        dashPattern: const [5, 3],
        borderType: BorderType.RRect,
        radius: const Radius.circular(8),
        child: Container(
          height: 80,
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: image != null
              ? Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                image,
                fit: BoxFit.cover,
              ),

              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                  ),
                ),
              ),
            ],
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             SvgPicture.asset(Images.uploadIcon),
              const SizedBox(height: 6),
              CustomWidget().buildTextWidget(
                title: title,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}