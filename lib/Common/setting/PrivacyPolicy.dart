import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../controller/ProfileController.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final ProfileController controller = Get.put(ProfileController());

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.termsPrivacyApi();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          centerTitle: true,
          title: CustomWidget().buildTextWidget(
              title: "Privacy Policy",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.green500,
              ),
            );
          }
          if (controller.privacyUrl.value.isEmpty) {
            return const Center(
              child: Text("PDF URL not found"),
            );
          }
          return SfPdfViewer.network(
            controller.privacyUrl.value,
            enableDoubleTapZooming: false,
            initialZoomLevel: 1.0,
            maxZoomLevel: 3.0,
            interactionMode: PdfInteractionMode.pan,
            onDocumentLoaded: (details) {
              debugPrint("PDF Loaded Successfully");
            },
            onDocumentLoadFailed: (details) {
              debugPrint("PDF Error: ${details.error}");
              debugPrint("Description: ${details.description}");

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Failed to load PDF: ${details.description}",
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
