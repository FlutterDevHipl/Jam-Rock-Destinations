import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'ProfileController.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
}


class _TermsAndConditionsScreenState
    extends State<TermsAndConditionsScreen> {
   final ProfileController  controller = Get.put(ProfileController());


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
        title: CustomWidget().buildTextWidget(title: "Terms & Conditions",textColor: AppColors.black500,fontWeight: FontWeight.w700,fontSize: 20)
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (controller.termsUrl.value.isEmpty) {
          return const Center(
            child: Text("PDF URL not found"),
          );
        }
        return SfPdfViewer.network(
          controller.termsUrl.value,
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
    );
  }
}