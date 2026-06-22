import 'dart:convert';
import 'dart:io';

import 'package:Jam_Rock_Destinations/Services/api_provider.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_connect/http/src/multipart/form_data.dart';
import 'package:get/get_connect/http/src/multipart/multipart_file.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

import '../Utils/api_url.dart';
import '../Utils/app_colors.dart';
import '../Utils/storage.dart';
import 'package:http/http.dart' as http;
class UpdateDocumentController extends GetxController {
  final Rx<File?> governmentFrontImage = Rx<File?>(null);
  final Rx<File?> governmentBackImage = Rx<File?>(null);

  final Rx<File?> licenseFrontImage = Rx<File?>(null);
  final Rx<File?> licenseBackImage = Rx<File?>(null);

  final Rx<File?> crbFrontImage = Rx<File?>(null);
  final Rx<File?> crbBackImage = Rx<File?>(null);

  final governmentFrontUrl = ''.obs;
  final governmentBackUrl = ''.obs;

  final licenseFrontUrl = ''.obs;
  final licenseBackUrl = ''.obs;

  final crbFrontUrl = ''.obs;
  final crbBackUrl = ''.obs;

  final ImagePicker picker = ImagePicker();
  final isLoading = false.obs;
  final isKycDoc = false.obs;

  // @override
  // void onInit() {
  //   super.onInit();
  //   getKycDoc();
  // }
  void showDocumentUpdatePopup({
    required Function() onProceed,
    required Function() onCancel,
  }) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 28,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Warning Icon
                SvgPicture.asset(Images.kycDoc),

                const SizedBox(height: 24),

                CustomWidget().buildTextWidget(
                  title: "Document Update\nRequest",
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  textAlign: TextAlign.center,
                  textColor: AppColors.black500,
                ),

                const SizedBox(height: 20),

                CustomWidget().buildTextWidget(
                  title:
                  "Your updated documents will be\nreviewed by our team.",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  textColor: AppColors.black400,
                ),

                const SizedBox(height: 10),

                CustomWidget().buildTextWidget(
                  title:
                  "Your account will be on hold\nuntil verification is complete.",
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  textColor: AppColors.black400,
                ),

                const SizedBox(height: 28),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: onCancel,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(0, 50),
                          side: BorderSide(
                            color: AppColors.black400,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 16),

                    Expanded(
                      child: ElevatedButton(
                        onPressed: onProceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF4A100),
                          minimumSize: const Size(0, 50),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Proceed",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
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
        );
      },
    );
  }
  Future<void> pickImage(Rx<File?> imageFile) async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      imageFile.value = File(image.path);
    }
  }
  RxInt governmentDocId = 0.obs;
  RxInt licenseDocId = 0.obs;
  RxInt crbDocId = 0.obs;
  Future<void> getKycDoc() async {
    try {
      isLoading.value=true;
      var response = await ApiProvider().getRequest(
        apiUrl: AppConstants.getKYCDoc,
        token: getToken(),
      );

      if (response["success"]) {
        print("KYC = $response");

        final docs = response["data"]["user"]["driver_profile"]["documents"];

        final government = docs.firstWhere(
              (e) => e["document_type"] == "government_id",
        );

        final license = docs.firstWhere(
              (e) => e["document_type"] == "driving_license",
        );

        final crb = docs.firstWhere(
              (e) => e["document_type"] == "criminal_background_check",
        );
        governmentDocId.value = government["document_upload_id"];
        licenseDocId.value = license["document_upload_id"];
        crbDocId.value = crb["document_upload_id"];
        governmentFrontUrl.value = government["front_url"] ?? "";
        governmentBackUrl.value = government["back_url"] ?? "";

        licenseFrontUrl.value = license["front_url"] ?? "";
        licenseBackUrl.value = license["back_url"] ?? "";

        crbFrontUrl.value = crb["front_url"] ?? "";
        crbBackUrl.value = crb["back_url"] ?? "";
        isLoading.value=false;
        print("Front Image: ${governmentFrontImage.value}");
        print("Back Image: ${governmentBackImage.value}");
        print("Front URL: ${governmentFrontUrl.value}");
        print("Back URL: ${governmentBackUrl.value}");
      }
    } catch (e) {
      print(e);
      isLoading.value=false;
    }
    finally{
      isLoading.value=false;
    }
  }




  Future<void> updateKycDocuments() async {
    try {
      isKycDoc.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.uploadKYCDoc),
      );

      request.headers.addAll({
        "Authorization": "Bearer ${getToken()}",
        "Accept": "application/json",
      });

      int index = 0;

      // Criminal Background Check
      if (crbFrontImage.value != null ||
          crbBackImage.value != null) {
        request.fields['documents[$index][document_id]'] =
            crbDocId.value.toString(); // e.g. 6

        if (crbFrontImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][front_image]',
              crbFrontImage.value!.path,
            ),
          );
        }

        if (crbBackImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][back_image]',
              crbBackImage.value!.path,
            ),
          );
        }

        index++;
      }

      // Driving License
      if (licenseFrontImage.value != null ||
          licenseBackImage.value != null) {
        request.fields['documents[$index][document_id]'] =
            licenseDocId.value.toString(); // e.g. 5

        if (licenseFrontImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][front_image]',
              licenseFrontImage.value!.path,
            ),
          );
        }

        if (licenseBackImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][back_image]',
              licenseBackImage.value!.path,
            ),
          );
        }

        index++;
      }

      // Government ID
      if (governmentFrontImage.value != null ||
          governmentBackImage.value != null) {
        request.fields['documents[$index][document_id]'] =
            governmentDocId.value.toString(); // e.g. 4

        if (governmentFrontImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][front_image]',
              governmentFrontImage.value!.path,
            ),
          );
        }

        if (governmentBackImage.value != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'documents[$index][back_image]',
              governmentBackImage.value!.path,
            ),
          );
        }

        index++;
      }

      if (index == 0) {
        CustomWidget().showCustomToast(
          message: "Please select at least one document",
          backgroundColor: Colors.red,
        );
        return;
      }

      print("Fields => ${request.fields}");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("Response => ${response.body}");

      final responseData = jsonDecode(response.body);

      if (responseData["success"] == true) {
        CustomWidget().showCustomToast(
          message: responseData["message"] ??
              "Documents updated successfully",
          backgroundColor: AppColors.green500,
        );
        await getKycDoc(); // Refresh KYC data
      } else {
        CustomWidget().showCustomToast(
          message: responseData["message"] ?? "Something went wrong",
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      print("KYC Update Error => $e");

      CustomWidget().showCustomToast(
        message: "Something went wrong",
        backgroundColor: Colors.red,
      );
    } finally {
      isKycDoc.value = false;
    }
  }
  //****************************** Vehicle Management **************************//
  final RxString vehicleTypeError = "".obs;
  final RxString vehicleCapacityError = "".obs;

  final regNoController = TextEditingController();
  final modelController = TextEditingController();

  final vehicleCapacities = <String>[
    '2',
    '3',
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
  final vehicleDocumentFrontUrl = ''.obs;
  final vehicleDocumentBackUrl = ''.obs;

  final interiorImage1Url = ''.obs;
  final interiorImage2Url = ''.obs;

  final exteriorImage1Url = ''.obs;
  final exteriorImage2Url = ''.obs;
  final exteriorImage3Url = ''.obs;
  final exteriorImage4Url = ''.obs;
  final ImagePicker vehiclePicker = ImagePicker();

  Future<void> vehiclePickImage(Rx<File?> imageFile) async {
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      imageFile.value = File(image.path);
    }
  }


  final selectedImage = Rxn<File>();
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
  Future<void> getVehicleDetails() async {
    try {
      isLoading.value = true;

      var response = await ApiProvider().getRequest(
        apiUrl: AppConstants.getVehicleDetails,
        token: getToken(),
      );

      if (response["success"] == true) {
        final vehicles = response["data"]["user"]["vehicles"] as List;

        if (vehicles.isNotEmpty) {
          final vehicle = vehicles.first;
          print("capacity = ${vehicle["capacity"]}");
          // Basic Details
          regNoController.text =
              vehicle["registration_number"] ?? "";

          selectedVehicleCapacity.value =
              vehicle["capacity"]?.toString();

          selectedVehicleTypeId.value =
              vehicle["vehicle_type"]?["id"] ?? 0;

          selectedVehicleType.value =
              vehicle["vehicle_type"]?["name"] ?? "";

          selectedVehicleBrandId.value =
              vehicle["vehicle_brand"]?["id"] ?? 0;

          selectedVehicleBrand.value =
              vehicle["vehicle_brand"]?["name"] ?? "";
          modelController.text=selectedVehicleBrand.value;

          // Documents
          final documents = vehicle["documents"] as List;

          for (var doc in documents) {
            if (doc["document_type"] == "registration") {
              vehicleDocumentFrontUrl.value =
                  doc["front_url"] ?? "";

              vehicleDocumentBackUrl.value =
                  doc["back_url"] ?? "";
            }
          }

          // Images
          final images = vehicle["images"] as List;

          int interiorIndex = 0;
          int exteriorIndex = 0;

          for (var image in images) {
            if (image["image_type"] == "interior") {
              interiorIndex++;

              if (interiorIndex == 1) {
                interiorImage1Url.value =
                    image["image_url"] ?? "";
              } else if (interiorIndex == 2) {

                interiorImage2Url.value =
                    image["image_url"] ?? "";

              }
            }

            if (image["image_type"] == "exterior") {
              exteriorIndex++;
              switch (exteriorIndex) {
                case 1:
                  exteriorImage1Url.value =
                      image["image_url"] ?? "";
                  break;
                case 2:
                  exteriorImage2Url.value =
                      image["image_url"] ?? "";
                  break;
                case 3:
                  exteriorImage3Url.value =
                      image["image_url"] ?? "";
                  break;
                case 4:
                  exteriorImage4Url.value =
                      image["image_url"] ?? "";
                  break;
              }
            }
          }
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> updateVehicle() async {
    try {
      isLoading.value = true;

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(AppConstants.updateVehicleDetails),
      );

      request.headers['Authorization'] = 'Bearer ${getToken()}';
      request.headers['Accept'] = 'application/json';

      /// Basic Fields
      request.fields['vehicle_type_id'] =
          selectedVehicleTypeId.value.toString();

      request.fields['vehicle_brand_id'] =
          selectedVehicleBrandId.value.toString();

      request.fields['registration_number'] =
          regNoController.text.trim();

      request.fields['capacity'] =
          selectedVehicleCapacity.value ?? '';

      request.fields['model_number'] =
          modelController.text.trim();

      /// Vehicle Documents
      request.fields['documents[0][document_id]'] = '1';
      print(vehicleDocumentFront.value?.path);

      print(interiorImage1.value?.path);
      print(interiorImage2.value?.path);

      print(exteriorImage1.value?.path);
      print(exteriorImage2.value?.path);
      print(exteriorImage3.value?.path);
      print(exteriorImage4.value?.path);
      if (vehicleDocumentFront.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'documents[0][front_image]',
            vehicleDocumentFront.value!.path,
          ),
        );
      }
      else if(vehicleDocumentFrontUrl.value.isNotEmpty)
        {
          request.fields['documents[0][front_image]'] = '';
        }
      // else
      //   {
      //     request.fields['documents[0][front_image]'] = '';
      //   }

      // if (vehicleDocumentBack.value != null) {
      //   request.files.add(
      //     await http.MultipartFile.fromPath(
      //       'documents[0][back_image]',
      //       vehicleDocumentBack.value!.path,
      //     ),
      //   );
      // }else
      //   {
      //     request.files.add(
      //       await http.MultipartFile.fromPath(
      //         'documents[0][back_image]',
      //        "",
      //       ),
      //     );
      //   }
      print("back image!!!${vehicleDocumentBackUrl.value}");
      if (vehicleDocumentBack.value != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'documents[0][back_image]',
            vehicleDocumentBack.value!.path,
          ),
        );
      }
      else if(vehicleDocumentBackUrl.value.isNotEmpty)
        {
          request.fields['documents[0][back_image]'] = '';
        }
      else {

        // or 'null' depending on backend requirement
      }

      /// Images List
      // List<Map<String, dynamic>> images = [
      //   {
      //     'id': 1,
      //     'file': interiorImage1.value,
      //     'type': 'interior',
      //   },
      //   {
      //     'id': 2,
      //     'file': interiorImage2.value?.path,
      //     'type': 'interior',
      //   },
      //   {
      //     'id': 3,
      //     'file': exteriorImage1.value?.path,
      //     'type': 'exterior',
      //   },
      //   {
      //     'id': 4,
      //     'file': exteriorImage2.value?.path,
      //     'type': 'exterior',
      //   },
      //   {
      //     'id': 5,
      //     'file': exteriorImage3.value?.path,
      //     'type': 'exterior',
      //   },
      //   {
      //     'id': 6,
      //     'file': exteriorImage4.value?.path,
      //     'type': 'exterior',
      //   },
      // ];
      List<Map<String, dynamic>> images = [
        {
          "image_id": 1,
          "image": interiorImage1.value,
          "image_type": "interior",
        },
        {
          "image_id": 2,
          "image": interiorImage2.value,
          "image_type": "interior",
        },
        {
          "image_id": 3,
          "image": exteriorImage1.value,
          "image_type": "exterior",
        },
        {
          "image_id": 4,
          "image": exteriorImage2.value,
          "image_type": "exterior",
        },
        {
          "image_id": 5,
          "image": exteriorImage3.value,
          "image_type": "exterior",
        },
        {
          "image_id": 6,
          "image": exteriorImage4.value,
          "image_type": "exterior",
        },
      ];

      // for (int i = 0; i < images.length; i++) {
      //   final item = images[i];
      //
      //   request.fields['images[$i][image_id]'] =
      //       item['id'].toString();
      //
      //   request.fields['images[$i][image_type]'] =
      //   item['type'];
      //
      //   if (item['file'] != null) {
      //     request.files.add(
      //       await http.MultipartFile.fromPath(
      //         'images[$i][image]',
      //         item['file'].path,
      //       ),
      //     );
      //   }
      // }
      for (int i = 0; i < images.length; i++) {
        final item = images[i];

        request.fields['images[$i][image_id]'] =
            item['image_id'].toString();

        request.fields['images[$i][image_type]'] =
        item['image_type'];

        if (item['image'] != null) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'images[$i][image]',
              item['image'].path,
            ),
          );
        } else {
          request.fields['images[$i][image]'] = '';
        }
      }

      print("Requested fields ${request.fields}");

      var response = await request.send();

      var responseData =
      jsonDecode(await response.stream.bytesToString());

      print(responseData);

      if (response.statusCode == 200 ||
          response.statusCode == 201) {
        CustomWidget().showCustomToast(message:  responseData["message"],backgroundColor: AppColors.green500);
      } else {
        print("Error!$responseData");
        CustomWidget().showCustomToast(message:  responseData["message"] ?? "Something went wrong",backgroundColor: Colors.red);

      }
    } catch (e) {
      print("Update Vehicle Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}