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
import 'controller/UpdateDocumentController.dart';

class KycScreen extends  StatefulWidget{

  KycScreen({super.key});
  @override
  State<KycScreen> createState() => _KycScreenState();
}


class _KycScreenState extends State<KycScreen> {
  final UpdateDocumentController documentController =Get.put(UpdateDocumentController());
  void initState() {
    documentController.getKycDoc();

    // TODO: implement initState
    super.initState();
  }

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
          title: "KYC Documents",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: AppColors.blackColor,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(
            () =>  SizedBox(
              height: 52,
              child:
        
              CustomWidget().buildMaterialBtn(
                color:  documentController.governmentFrontImage.value != null ||
                    documentController.licenseFrontImage.value != null ||
                    documentController.crbFrontImage.value != null
                || documentController.governmentBackUrl.value.isEmpty
                ||documentController.licenseBackUrl.value.isEmpty
                ||documentController.crbBackUrl.value.isEmpty
                    ? AppColors.green500
                    : Colors.grey,
                radius: 8,
                height: 50,
                minWidth: double.maxFinite,
                textColor: Colors.white,
                text:documentController.isKycDoc.value?"Loading...": "Save",
                onPressed: () {
        
                  if (documentController.governmentFrontImage.value == null && documentController.governmentFrontUrl.isEmpty
                  ) {
                    CustomWidget().showCustomToast(
                      message: "Please Upload Government ID",
                    );
                    return;
                  }
                  else if (documentController.licenseFrontImage.value == null&& documentController.licenseFrontUrl.isEmpty) {
                    CustomWidget().showCustomToast(
                      message: "Please Upload Driving License",
                    );
                    return;
                  }
                  else if (documentController.crbFrontImage.value == null&& documentController.crbFrontUrl.isEmpty) {
                    CustomWidget().showCustomToast(
                      message: "Please Upload CRB Document",
                    );
                    return;
                  }
        
                  final hasData =
                      documentController.governmentFrontImage.value != null ||
                          documentController.licenseFrontImage.value != null ||
                          documentController.crbFrontImage.value != null
                          || documentController.governmentBackUrl.value.isEmpty
                          ||documentController.licenseBackUrl.value.isEmpty
                          ||documentController.crbBackUrl.value.isEmpty
                  ;

                  hasData
                      ? documentController.updateKycDocuments()
                      : print("No data uploaded");
        
              // documentController.showDocumentUpdatePopup(onProceed: () {
              //
              // }, onCancel: () {
              //   Get.back();
              // },);
        
                },
                // child: CustomWidget().buildTextWidget(
                //   title: "Save & Next",
                //   textColor:
                //   Colors.white,
                //   fontSize: 16,
                //   fontWeight: FontWeight.w600,
                // ),
                // CustomWidget().buildMaterialBtn(
                //   color: (controller.hasChanges.value ||
                //       controller.selectedImage.value != null)
                //       ? AppColors.green500
                //       : Colors.grey,
                //   radius: 8,
                //   height: 50,
                //   minWidth: double.maxFinite,
                //   textColor: Colors.white,
                //   text: "Save",
                //   onPressed: () {
                //     print(controller.selectedImage.value);
                //     if (controller.hasChanges.value ||
                //         controller.selectedImage.value != null) {
                //       controller.editProfile();
                //     }
                //   },
                // ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        child: Obx(
          () =>
              documentController.isLoading.value?
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.green500,
                  ),
                ),
              )
              :
              Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 20),


              _documentSection(
                title: "Government ID",
                frontImage: documentController.governmentFrontImage,
                backImage: documentController.governmentBackImage,
                frontUrl: documentController.governmentFrontUrl,
                backUrl: documentController.governmentBackUrl,
              ),

              const SizedBox(height: 20),


              _documentSection(
                title: "Driving License",
                frontImage: documentController.licenseFrontImage,
                backImage: documentController.licenseBackImage,
                frontUrl: documentController.licenseFrontUrl,
                backUrl: documentController.licenseBackUrl,
              ),

              const SizedBox(height: 20),


              _documentSection(
                title: "CRB (Criminal Record Background) Check ",
                frontImage: documentController.crbFrontImage,
                backImage: documentController.crbBackImage,
                frontUrl: documentController.crbFrontUrl,
                backUrl: documentController.crbBackUrl,
              ),

              const SizedBox(height: 25),

              Center(
                child: Column(
                  children: [
                    CustomWidget().buildTextWidget(
                      title: "Upload clear & valid documents",
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.black400,
                    ),
                    CustomWidget().buildTextWidget(
                      title: "(JPG, PNG or PDF · Max 5MB)",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.green500,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _documentSection({
    required String title,
    required Rx<File?> frontImage,
    required Rx<File?> backImage,
    required RxString frontUrl,
    required RxString backUrl,
  }){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomWidget().buildTextWidget(
          title: title,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          textColor: AppColors.black300,
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
                        imageUrl: frontUrl.value,
                        onTap: () => documentController.pickImage(frontImage),
                        onRemove: () {
                          frontImage.value = null;
                          frontUrl.value = '';
                        },
                      ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Obx(
                      () => _uploadBox(
                        title: "Back (Optional)",
                        image: backImage.value,
                        imageUrl: backUrl.value,
                        onTap: () => documentController.pickImage(backImage),

                        onRemove: () {
                          print("Clicked");
                          backImage.value = null;
                          backUrl.value = '';
                        },                      ),
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
    required VoidCallback onRemove,
    File? image,
    String? imageUrl,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          DottedBorder(
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
                color: Colors.white
              ),
              child: image != null
                  ? Image.file(
                image,
                fit: BoxFit.cover,
              )
                  : (imageUrl != null && imageUrl.isNotEmpty)
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
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

          // Edit icon overlapping border
          if (image != null || (imageUrl != null && imageUrl.isNotEmpty))
            Positioned(
              top: -6,
              right: -6,
              child: GestureDetector(
                onTap: onRemove,
                child: Container(
                  padding: const EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: AppColors.green500,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.green500,
                    ),
                  ),
                  child: const Icon(
                    CupertinoIcons.multiply,
                    size: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}