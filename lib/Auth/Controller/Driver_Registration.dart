import 'dart:developer';
import 'dart:io';

import 'package:Jam_Rock_Destinations/Driver/driver_bottom_navigation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Services/api_provider.dart';
import '../../Utils/api_url.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/custom_widget.dart';
import '../ProfileUnderReview.dart';
import '../profileSetup2.dart';

class VehicleDetailsController extends GetxController {
final isLoading=false.obs;
  /// Text Controllers
  final regNoController = TextEditingController();
  final modelController = TextEditingController();

/// Validation check for vehicle reg number
  bool isValidJamaicaVehicleNumber(String value) {
    final regex = RegExp(r'^\d{4,5}\s?[A-Z]{2}$');
    return regex.hasMatch(value.trim().toUpperCase());
  }
  final RxString vehicleTypeError = "".obs;
  final RxString vehicleCapacityError = "".obs;



  final vehicleCapacities = <String>[
    '2',
    '4',
    '5',
    '6',
    '7',
    '8',
  ].obs;

  final selectedVehicleCapacity = RxnString();

  /// Vehicle Document

  final vehicleDocumentFront = Rx<File?>(null);
  final vehicleDocumentBack = Rx<File?>(null);

  /// Interior Images

  final interiorImage1 = Rx<File?>(null);
  final interiorImage2 = Rx<File?>(null);

  /// Exterior Images

  final exteriorImage1 = Rx<File?>(null);
  final exteriorImage2 = Rx<File?>(null);
  final exteriorImage3 = Rx<File?>(null);
  final exteriorImage4 = Rx<File?>(null);

  final ImagePicker picker = ImagePicker();


Future<void> pickImage(Rx<File?> imageFile) async {
  Get.bottomSheet(
    Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.camera,
                  imageQuality: 80,
                );
        
                if (image != null) {
                  imageFile.value = File(image.path);
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () async {
                Get.back();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                  imageQuality: 80,
                );
        
                if (image != null) {
                  imageFile.value = File(image.path);
                }
              },
            ),
          ],
        ),
      ),
    ),
  );
}



  ///Profile Step 1
final Rx<File?> governmentFrontImage = Rx<File?>(null);
final Rx<File?> governmentBackImage = Rx<File?>(null);
final selectedImage = Rxn<File>();
final Rx<File?> licenseFrontImage = Rx<File?>(null);
final Rx<File?> licenseBackImage = Rx<File?>(null);
final Rx<File?> crbFrontImage = Rx<File?>(null);
final Rx<File?> crbBackImage = Rx<File?>(null);



RxList<Map<String, dynamic>> vehicleTypes = <Map<String, dynamic>>[].obs;

RxList<Map<String, dynamic>> vehicleBrands = <Map<String, dynamic>>[].obs;

RxInt selectedVehicleTypeId = 0.obs;
RxInt selectedVehicleBrandId = 0.obs;

RxString selectedVehicleType = ''.obs;
RxString selectedVehicleBrand = ''.obs;

RxBool isLoadingVehicleTypes = false.obs;
RxBool isLoadingVehicleBrands = false.obs;

RxString vehicleBrandError = "".obs;

Future<void> getVehicleData(String type) async {
  try {
    isLoading.value = true;

    List<Map<String, dynamic>> allItems = [];
    int currentPage = 1;
    int lastPage = 1;

    do {
      var response = await ApiProvider().getRequestWithBody(
        apiUrl: AppConstants.getVehicles,
        body: {
          "type": type,
          "page": currentPage,
        },
      );

      if (response != null) {
        allItems.addAll(
          (response["data"] as List)
              .map<Map<String, dynamic>>(
                (e) => {
              "id": e["id"],
              "name": e["name"],
            },
          ).toList(),
        );

        lastPage = response["meta"]["last_page"] ?? 1;
        currentPage++;
      }
    } while (currentPage <= lastPage);

    if (type == "vehicle_type") {
      vehicleTypes.assignAll(allItems);
    } else {
      final uniqueBrands = allItems.toSet().toList();
      vehicleBrands.assignAll(uniqueBrands);
      // vehicleBrands.assignAll(allItems);
    }

print("vehicleBrands = $vehicleBrands");
    print("Total Loaded: ${allItems.length}");
  } catch (e) {
    debugPrint("Error: $e");
  } finally {
    isLoading.value = false;
  }
}


  Future<void> driverRegistration(String token,final step) async {
    try {
      isLoading.value = true;
      final requestData = {
          "register_step": step,
          "register_type": "normal",
          "user_type": "driver",
          "registration_token": token,
      };
final requestData2 = {
  "government_id_front": governmentFrontImage.value,
  "government_id_back": governmentBackImage.value,
  "driving_license_front": licenseFrontImage.value,
  "driving_license_back": licenseBackImage.value,
  "criminal_background_check_front": crbFrontImage.value,
  "criminal_background_check_back": crbBackImage.value
};
final requestData4={
  "register_step": 3,
  "register_type": "normal",
  "user_type": "driver",
  "registration_token": "d494a1d0-2c2b-4987-9822-06048740729e",
  "vehicle_type_id": 1,
  "vehicle_brand_id": 1,
  "vehicle_registration_number": "RJ14SM8576",
  "vehicle_model": "TOP",
  "vehicle_capacity": 3,
  "vehicle_document_front": "file",
  "vehicle_document_back": "file",
  "vehicle_interior_images": ["file1", "file2", "file3"],
  "vehicle_exterior_images": ["file1", "file2"]
};

      print(requestData);
print(requestData2);

      var response = await ApiProvider().putRequestProfileWithDocuments(
        apiUrl: AppConstants.register,
        fields: requestData,
        documents: requestData2
      );

      print("Register Response: $response");

      if (response['success'] == true) {
        CustomWidget().showCustomToast(
          message: response['message'] ?? "Registration successful",
          backgroundColor: AppColors.green500,
        );

        print("registration_token step 2 = ${response["data"]["registration_token"]}");
        print("registration_token step  = ${response["data"]["next_step"]}");
        Get.to(VehicleDetailsView(token: response["data"]["registration_token"],step: response["data"]["next_step"],));

      } else {
        String errorMessage =
            response['message']?.toString() ?? "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {

          final firstValue = response['errors'].values.first;

          if (firstValue is List && firstValue.isNotEmpty) {
            errorMessage = firstValue.first.toString();
          } else if (firstValue is String) {
            errorMessage = firstValue;
          }
        }

        CustomWidget().showCustomToast(
          message: errorMessage,
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("Register Error: $e");
    } finally {
      isLoading.value = false;
    }
  }


Future<void> driverRegistration2(String token, int step) async {
  try {
    isLoading.value = true;

    final fields = {
      "register_step": 3,
      "register_type": "normal",
      "user_type": "driver",
      "registration_token": token,
      "vehicle_type_id": selectedVehicleTypeId.value,
      "vehicle_brand_id": selectedVehicleBrandId.value,
      "vehicle_registration_number": regNoController.text.trim(),
      "vehicle_model": modelController.text.trim(),
      "vehicle_capacity": selectedVehicleCapacity,
    };
    final documents={
      "vehicle_document_front": vehicleDocumentFront.value,
      "vehicle_document_back": vehicleDocumentBack.value,
    };
    final multipleDocuments={
      "vehicle_interior_images": [
        if (interiorImage1.value != null) interiorImage1.value!,
        if (interiorImage2.value != null) interiorImage2.value!,
      ],
      "vehicle_exterior_images": [
        if (exteriorImage1.value != null) exteriorImage1.value!,
        if (exteriorImage2.value != null) exteriorImage2.value!,
        if (exteriorImage3.value != null) exteriorImage3.value!,
        if (exteriorImage4.value != null) exteriorImage4.value!,
      ],
    };

    final response = await ApiProvider().putRequestProfileWithDocuments2(
      apiUrl: AppConstants.register,
      fields:fields,
      documents:documents,
      multipleDocuments:multipleDocuments
      // {
      //   "vehicle_interior_images": [
      //     if (interiorImage1.value != null) interiorImage1.value!,
      //     if (interiorImage2.value != null) interiorImage2.value!,
      //   ],
      //   "vehicle_exterior_images": [
      //     if (exteriorImage1.value != null) exteriorImage1.value!,
      //     if (exteriorImage2.value != null) exteriorImage2.value!,
      //     if (exteriorImage3.value != null) exteriorImage3.value!,
      //     if (exteriorImage4.value != null) exteriorImage4.value!,
      //   ],
      // },
    );
    print(response);

    if (response["success"] == true) {
      CustomWidget().showCustomToast(
        message: response["message"],
        backgroundColor: AppColors.green500,
      );

      print("registration_token step 2 = ${response["data"]["registration_token"]}");
      print("registration_token step  = ${response["data"]["next_step"]}");
      print("Step 3");
      driverRegistration3(response["data"]["registration_token"]);
      Get.offAll(ProfileReviewView(token: response["data"]["registration_token"]));
      // Get.to(
      //   VehicleDetailsView(
      //     token: response["data"]["registration_token"],
      //     step: response["data"]["next_step"],
      //   ),
      // );
    } else {
      print("Response !! $response");

      String errorMessage =
          response['message']?.toString() ?? "Registration failed";

      if (response['errors'] != null &&
          response['errors'] is Map &&
          response['errors'].isNotEmpty) {

        final firstValue = response['errors'].values.first;

        if (firstValue is List && firstValue.isNotEmpty) {
          errorMessage = firstValue.first.toString();
        } else if (firstValue is String) {
          errorMessage = firstValue;
        } else {
          errorMessage = firstValue.toString();
        }
      }

      CustomWidget().showCustomToast(
        message: errorMessage,
        backgroundColor: Colors.red,
      );
    }
  } catch (e) {
    print("Error => $e");
  } finally {
    isLoading.value = false;
  }
}
Future<void> driverRegistration3(String token) async {
  try {
    isLoading.value = true;

    final fields = {
        "register_step": "4",
        "register_type": "normal",
        "user_type": "driver",
        "registration_token": token,
    };

    final response = await ApiProvider().postRequest1(
        apiUrl: AppConstants.register,
       data: fields
    );
    print(response);

    if (response["success"] == true) {
      CustomWidget().showCustomToast(
        message: response["message"],
        backgroundColor: AppColors.green500,

      );
      print("Step 4");
      print("Registration success ${response["data"]}");

    } else {
      print("else  $response");
      ApiProvider().showErrorFromResponse(response);
    }
  } catch (e) {
    print("Error !!!=> $e");
  } finally {
    isLoading.value = false;
  }
}
  @override
  void onClose() {
    regNoController.dispose();
    modelController.dispose();
    super.onClose();
  }
}