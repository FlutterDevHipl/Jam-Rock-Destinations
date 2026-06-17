import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../Services/api_provider.dart';
import '../../Utils/api_url.dart';
import '../../Utils/app_colors.dart';
import '../../Utils/custom_widget.dart';
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
    '2 Seats',
    '4 Seats',
    '5 Seats',
    '6 Seats',
    '7 Seats',
    '8 Seats',
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
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      imageFile.value = File(image.path);
    }
  }




  ///Profile Step 1
final Rx<File?> governmentFrontImage = Rx<File?>(null);
final Rx<File?> governmentBackImage = Rx<File?>(null);
final selectedImage = Rxn<File>();
final Rx<File?> licenseFrontImage = Rx<File?>(null);
final Rx<File?> licenseBackImage = Rx<File?>(null);
final Rx<File?> crbFrontImage = Rx<File?>(null);
final Rx<File?> crbBackImage = Rx<File?>(null);



final  vehicleTypes = <String>[].obs;
final vehicleBrands = <String>[].obs;


RxBool isLoadingVehicleTypes = false.obs;
RxBool isLoadingVehicleBrands = false.obs;
RxString selectedVehicleType = ''.obs;
RxString selectedVehicleBrand = ''.obs;
RxString vehicleBrandError = "".obs;
Future<void> getVehicleData(String type) async {
  try {
    isLoading.value = true;

    List<String> allItems = [];
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
              .map<String>((e) => e["name"].toString())
              .toList(),
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
// Future<void> getVehicleData(String type) async {
//   try {
//     isLoading.value = true;
//
//     var response = await ApiProvider().getRequestWithBody(
//       apiUrl: AppConstants.getVehicles,
//       body: {
//         "type": type, // vehicle_type or vehicle_brand
//         "per_page": 100,
//       },
//     );
//
//     if (response != null && response["data"] != null) {
//       if (type == "vehicle_type") {
//         vehicleTypes.assignAll(
//           (response["data"] as List)
//               .map<String>((e) => e["name"].toString())
//               .toList(),
//         );
//
//         print("vehicleTypes $vehicleTypes"); // [Sedan, SUV]
//         // selectedVehicleType.value='';
//       }
//       else {
//         vehicleBrands.assignAll(
//           (response["data"] as List)
//               .map((e) => e["name"].toString())
//               .toList(),
//         );
//
//         print("vehicleBrands $vehicleBrands");
//         // selectedVehicleBrand.value='';
//       }
//     }
//   } catch (e) {
//     debugPrint("Error: $e");
//   } finally {
//     isLoading.value = false;
//   }
// }

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
        if(step == 2)
          {
            Get.to(VehicleDetailsView(token: response["data"]["registration_token"],step: response["data"]["next_step"],));
          }




      } else {
        String errorMessage = "Registration failed";

        if (response['errors'] != null &&
            response['errors'] is Map &&
            response['errors'].isNotEmpty) {
          final firstKey = response['errors'].keys.first;
          errorMessage = response['errors'][firstKey].first.toString();
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
  @override
  void onClose() {
    regNoController.dispose();
    modelController.dispose();
    super.onClose();
  }
}