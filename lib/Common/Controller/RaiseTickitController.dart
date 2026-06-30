import 'dart:developer';

import 'package:Jam_Rock_Destinations/Services/api_provider.dart';
import 'package:Jam_Rock_Destinations/Utils/api_url.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../Utils/storage.dart';

class RaiseTickitcontroller extends GetxController {
  var isLoading = false.obs;
  RxBool isFormValid = false.obs;

  RxnString selectedIssue = RxnString(null);
  final issueController = TextEditingController();

  final List<String> issues = [
    "Payment Issue",
    "Booking Issue",
    "Driver Issue",
    "App Issue",
    "Other",
  ];

  @override
  void onInit() {
    super.onInit();

    issueController.addListener(_validateForm);

    ever(selectedIssue, (_) => _validateForm());
  }

  void _validateForm() {
    isFormValid.value =
        issueController.text.trim().isNotEmpty && selectedIssue.value != null;
  }

  @override
  void onClose() {
    issueController.dispose();
    super.onClose();
  }

  Future<void> raiseTickit() async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.createTickit,
        token: getToken(),
        data: {
          "category": selectedIssue.value,
          "message": issueController.text.trim()
        },
      );

      if (response['success'] == true) {
        log("response $response");
        CustomWidget().showCustomToast(
            message: response['message'], backgroundColor: AppColors.green500);
        selectedIssue.value = null;
        issueController.clear();
        Get.back();
      } else {
        ApiProvider().showErrorFromResponse(response);
      }
    } catch (e) {
      debugPrint("$e");
    } finally {
      isLoading.value = false;
    }
  }
}
