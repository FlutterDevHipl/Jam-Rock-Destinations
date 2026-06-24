import 'dart:io';

import 'package:Jam_Rock_Destinations/Auth/ProfileUnderReview.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Auth/Controller/Driver_Registration.dart';
import '../Utils/app_colors.dart';
import '../Utils/custom_widget.dart';
import 'controller/UpdateDocumentController.dart';


class VehicleDetailsView extends StatefulWidget {

  const VehicleDetailsView({super.key});


  @override
  State<VehicleDetailsView> createState() => _VehicleDetailsViewState();
}

class _VehicleDetailsViewState extends State<VehicleDetailsView> {
  final UpdateDocumentController controller = Get.put(UpdateDocumentController());
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {

    controller.getVehicleData("vehicle_type");
    controller.getVehicleData("vehicle_brand");

    // TODO: implement initState
    super.initState();
    controller.getVehicleDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        title: CustomWidget().buildTextWidget(
          title: "Vehicle Management",
          fontSize: 20,
          fontWeight: FontWeight.w700,
          textColor: AppColors.blackColor,
        ),

      ),

      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child:
               CustomWidget().buildMaterialBtn(text:"Submit",
                color:
                // (controller.exteriorImage1.value == null &&
                //     controller.exteriorImage1Url.value.isEmpty||controller.exteriorImage1Url.value=="") ||
                //
                //     (controller.exteriorImage2.value == null &&
                //         controller.exteriorImage2Url.value=="") ||
                //
                //     (controller.exteriorImage3.value == null &&
                //         controller.exteriorImage3Url.value=="") ||
                //
                //     (controller.exteriorImage4.value == null &&
                //         controller.exteriorImage4Url.value=="") ||
                //
                //     (controller.vehicleDocumentFront.value == null &&
                //         controller.vehicleDocumentFrontUrl.value=="") ||
                //
                //     (controller.vehicleDocumentBack.value == null &&
                //         controller.vehicleDocumentBackUrl.value=="")
                //     || controller.hasChanges.value==false?
                // Colors.grey:
                AppColors.green500,
                radius: 8,
                onPressed: () {
                  bool isValid = true;
                  controller.vehicleTypeError.value = "";
                  controller.vehicleBrandError.value = "";
                  controller.vehicleCapacityError.value = "";

                  if (controller.selectedVehicleType.value=="" || controller.selectedVehicleType.value.isEmpty) {
                    controller.vehicleTypeError.value =
                    "Please Select Vehicle Type";
                    isValid = false;
                  }
                  if (controller.selectedVehicleBrand.value=="" ||controller.selectedVehicleBrand.value.isEmpty) {
                    controller.vehicleBrandError.value =
                    "Please Select Vehicle Brand";
                    isValid = false;
                  }

                  if (controller.selectedVehicleCapacity.value==""||controller.selectedVehicleCapacity.value==null) {
                    controller.vehicleCapacityError.value =
                    "Please Select Vehicle Capacity";
                    isValid = false;
                  }

                  if (!formKey.currentState!.validate()) {
                    isValid = false;
                  }

                  if (controller.vehicleDocumentFront.value == null && controller.vehicleDocumentFrontUrl.isEmpty) {
                    CustomWidget().showCustomToast(
                      message: "Please Upload Vehicle Document",
                    );
                    isValid = false;
                  }

                  if (controller.interiorImage1.value == null &&  controller.interiorImage1Url.value.isEmpty ||
                      controller.interiorImage2.value == null && controller.interiorImage2Url.value.isEmpty) {

                    CustomWidget().showCustomToast(
                      message: "Please Upload Vehicle Interior Images",
                    );
                    isValid = false;
                  }
                  if (
                  controller.exteriorImage1.value == null && controller.exteriorImage1Url.value.isEmpty ||
                      controller.exteriorImage2.value == null && controller.exteriorImage2Url.value.isEmpty ||
                      controller.exteriorImage3.value == null && controller.exteriorImage3Url.value.isEmpty||
                      controller.exteriorImage4.value == null &&  controller.exteriorImage4Url.value.isEmpty
                  ) {
                    CustomWidget().showCustomToast(
                      message: "Please Upload Vehicle Exterior Images",
                    );
                    isValid = false;
                  }
                  if (!isValid) return;
                  controller.updateVehicle();


                  // final hasImageData =
                  //     (controller.exteriorImage1.value == null &&
                  //         controller.exteriorImage1Url.value.isEmpty||controller.exteriorImage1Url.value=="") ||
                  //
                  //         (controller.exteriorImage2.value == null &&
                  //             controller.exteriorImage2Url.value=="") ||
                  //
                  //         (controller.exteriorImage3.value == null &&
                  //             controller.exteriorImage3Url.value=="") ||
                  //
                  //         (controller.exteriorImage4.value == null &&
                  //             controller.exteriorImage4Url.value=="") ||
                  //
                  //         (controller.vehicleDocumentFront.value == null &&
                  //             controller.vehicleDocumentFrontUrl.value=="") ||
                  //
                  //         (controller.vehicleDocumentBack.value == null &&
                  //             controller.vehicleDocumentBackUrl.value=="");
                  // print("hasImageData = $hasImageData");
                  // print("hasChanges = ${controller.hasChanges.value}");
                  // if(hasImageData||controller.hasChanges.value==true)
                  // {
                  //
                  // }



                  // governmentFrontImage.value != null ||
                  //     documentController.licenseFrontImage.value != null ||
                  //     documentController.crbFrontImage.value != null;
                  //
                  // hasData
                  //     ? documentController.updateKycDocuments()
                  //     : print("No data uploaded");


                  // controller.driverRegistration2(widget.token, widget.step);
                  //
                },
              ),)


        ),


      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Obx(
          () =>
              controller.isLoading.value?
              SizedBox(
                height: MediaQuery.of(context).size.height*0.8,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.green500,
                  ),
                ),
              ):
              Form(
            key: formKey,
            child:
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const SizedBox(height: 15),

                /// Vehicle Type
                _label("Vehicle Type"),

                Obx(
                      () => buildDropdown(
                    hint: "Select Vehicle Type",
                    prefixImage: Images.carIcon,
                    items: controller.vehicleTypes
                        .map((e) => e["name"].toString())
                        .toList(),
                    value: controller.selectedVehicleType.value.isEmpty
                        ? null
                        : controller.selectedVehicleType.value,
                    errorText: controller.vehicleTypeError.value,
                    onChanged: (value) {
                      final selected = controller.vehicleTypes.firstWhere(
                            (e) => e["name"] == value,
                      );
                      controller.hasChanges.value=true;
                      controller.selectedVehicleType.value = selected["name"];
                      controller.selectedVehicleTypeId.value = selected["id"];

                      print("Type ID: ${controller.selectedVehicleTypeId.value}");

                      controller.vehicleTypeError.value = '';
                    },
                  ),
                ),


                Obx(() =>   controller.vehicleTypeError.value.isNotEmpty?
                heightSpace16:heightSpace2,),

                /// Registration Number
                _label("Vehicle Reg. Number"),

                CustomWidget().buildTextFormField(
                  controller: controller.regNoController,
                  hintText: "Enter Reg. Number", darkMode: false,
                  radius: 8,
                  prefixIcon:SvgPicture.asset(Images.fileIcon,width: 24,height: 24,),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter registration number";
                    }

                    if (!RegExp(r'^\d{4,5}\s?[A-Z]{2}$').hasMatch(value.trim())) {
                      return "Please enter a valid registration number";
                    }

                    return null;
                  },
                  onChanged: (s) {
                    controller.hasChanges.value=true;
                  },
                ),

                const SizedBox(height: 16),

                /// Brand
                _label("Vehicle Brand"),

                Obx(
                      () => buildBrandDropdown(
                    hint: "Select vehicle brand",
                    items: controller.vehicleBrands
                        .map((e) => e["name"].toString())
                        .toList(),
                    value: controller.selectedVehicleBrand.value.isEmpty
                        ? null
                        : controller.selectedVehicleBrand.value,

                    prefixImage: Images.carEmailIcon,
                    errorText: controller.vehicleBrandError.value,
                    onChanged: (value) {
                      final selected = controller.vehicleBrands.firstWhere(
                            (e) => e["name"] == value,
                      );
                      controller.hasChanges.value=true;
                      controller.selectedVehicleBrand.value = selected["name"];
                      controller.selectedVehicleBrandId.value = selected["id"];

                      print("Brand Name: ${controller.selectedVehicleBrand.value}");
                      print("Brand Id: ${controller.selectedVehicleBrandId.value}");

                      controller.vehicleBrandError.value = "";
                    },
                  ),
                ),
                Obx(() =>   controller.vehicleBrandError.value.isNotEmpty?
                heightSpace5:heightSpace16,),
                Obx(
                      () =>
                  controller.vehicleBrandError.value!="" ?
                  SizedBox(height: 16): SizedBox(height: 0),
                ),
                // heightSpace16,

                /// Model
                CustomWidget().buildTextFormField(
                  controller: controller.modelController,
                  darkMode: false,
                  hintText: "Enter Model",
                  radius: 8,

                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter model number";
                    }

                    if (!RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(value.trim())) {
                      return "Model must contain only English letters and numbers";
                    }

                    return null;
                  },
                  onChanged: (s) {
                    controller.hasChanges.value=true;
                  },
                ),

                const SizedBox(height: 16),

                /// Capacity
                _label("Vehicle Capacity"),

                Obx(
                      () => buildDropdown(
                    hint: "Select Seat",
                    items: controller.vehicleCapacities,
                    value: controller.selectedVehicleCapacity.value,
                    prefixImage: Images.twoPerson,
                    errorText: (controller.selectedVehicleCapacity.value==""||controller.selectedVehicleCapacity.value==null)
                        ? controller.vehicleCapacityError.value
                        : null,
                    onChanged: (value) {
                      controller.selectedVehicleCapacity.value = value ?? "";
                      print( controller.selectedVehicleCapacity.value);
                      controller.hasChanges.value=true;
                      controller.vehicleCapacityError.value = "";
                    },
                  ),
                ),

                const SizedBox(height: 20),

                /// Vehicle Document
                _label("Vehicle Document"),

                // _documentSection(
                //   title: "",
                //   frontImage: controller.vehicleDocumentFront,
                //   backImage: controller.vehicleDocumentBack,
                // ),
                _documentSection(
                  title: "",
                  frontImage: controller.vehicleDocumentFront,
                  backImage: controller.vehicleDocumentBack,
                  frontUrl: controller.vehicleDocumentFrontUrl,
                  backUrl: controller.vehicleDocumentBackUrl,
                ),

                const SizedBox(height: 20),

                /// Vehicle Images
                _label("Vehicle Images"),

                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                  decoration: BoxDecoration(
                      color:  Color(0xffF7F7F7),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 1,color: AppColors.black50)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _labelSmall("Interior Images"),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Obx(
                                  () => _uploadBox(
                                image: controller.interiorImage1.value,
                                imageUrl: controller.interiorImage1Url.value,
                                onTap: () =>
                                    controller.pickImage(controller.interiorImage1),
                                title: '',
                                    onRemove: () {
                                      controller.interiorImage1.value=null;
                                      controller.interiorImage1Url.value='';
                                    },
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child:
                            Obx(
                                  () => _uploadBox(
                                image: controller.interiorImage2.value,
                                imageUrl: controller.interiorImage2Url.value,
                                onTap: () =>
                                    controller.pickImage(controller.interiorImage2),
                                title: '',
                                    onRemove: () {
                                      controller.interiorImage2.value=null;
                                      controller.interiorImage2Url.value='';
                                    },
                              ),
                            ),
                            // Obx(
                            //       () => _uploadBox(
                            //     image: controller.interiorImage2.value,
                            //     onTap: () =>
                            //         controller.pickImage(controller.interiorImage2), title: '',
                            //   ),
                            // ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      _labelSmall("Exterior Images"),

                      const SizedBox(height: 10),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2.0,
                        children: [
                          // Obx(() => _uploadBox(
                          //   image: controller.exteriorImage1.value,
                          //   onTap: () =>
                          //       controller.pickImage(controller.exteriorImage1), title: '',
                          // )),
                          Obx(
                                () => _uploadBox(
                              image: controller.exteriorImage1.value,
                              imageUrl: controller.exteriorImage1Url.value,
                              onTap: () =>
                                  controller.pickImage(controller.exteriorImage1),
                              title: '',
                                  onRemove: () {
                                    controller.exteriorImage1.value=null;
                                    controller.exteriorImage1Url.value='';
                                  },
                            ),
                          ),
                          // Obx(() => _uploadBox(
                          //   image: controller.exteriorImage2.value,
                          //   onTap: () =>
                          //       controller.pickImage(controller.exteriorImage2), title: '',
                          // )),
                          Obx(
                                () => _uploadBox(
                              image: controller.exteriorImage2.value,
                              imageUrl: controller.exteriorImage2Url.value,
                              onTap: () =>
                                  controller.pickImage(controller.exteriorImage2),
                              title: '',
                                  onRemove: () {
                                    controller.exteriorImage2.value=null;
                                    controller.exteriorImage2Url.value='';
                                  },
                            ),
                          ),
                          // Obx(() => _uploadBox(
                          //   image: controller.exteriorImage3.value,
                          //   onTap: () =>
                          //       controller.pickImage(controller.exteriorImage3), title: '',
                          // )),
                          Obx(
                                () => _uploadBox(
                              image: controller.exteriorImage3.value,
                              imageUrl: controller.exteriorImage3Url.value,
                              onTap: () =>
                                  controller.pickImage(controller.exteriorImage3),
                              title: '',
                                  onRemove: () {
                                    controller.exteriorImage3.value=null;
                                    controller.exteriorImage3Url.value='';
                                  },
                            ),
                          ),
                          Obx(
                                () => _uploadBox(
                              image: controller.exteriorImage4.value,
                              imageUrl: controller.exteriorImage4Url.value,
                              onTap: () =>
                                  controller.pickImage(controller.exteriorImage4),
                              title: '',
                                  onRemove: () {
                                    controller.exteriorImage4.value=null;
                                    controller.exteriorImage4Url.value='';
                                  },
                            ),
                          ),
                          // Obx(() => _uploadBox(
                          //   image: controller.exteriorImage4.value,
                          //   onTap: () =>
                          //       controller.pickImage(controller.exteriorImage4), title: '',
                          // )),
                        ],
                      ),
                    ],),),



                const SizedBox(height: 20),

                Center(
                  child: Column(
                    children: [
                      CustomWidget().buildTextWidget(
                        title: "Upload clear & valid documents",
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        textColor: AppColors.black400,
                      ),
                      CustomWidget().buildTextWidget(
                        title: "(JPG, PNG or PDF · Max 5MB)",
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        textColor: AppColors.green500,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: CustomWidget().buildTextWidget(
        title: text,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        textColor: AppColors.black400,
      ),
    );
  }

  Widget _labelSmall(String text) {
    return CustomWidget().buildTextWidget(
      title: text,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      textColor: AppColors.black400,
    );
  }
  // Widget buildDropdown({
  //   required String hint,
  //   required List<String> items,
  //   required String? value,
  //   required Function(String?) onChanged,
  //   String? prefixImage,
  //   String? Function(String?)? validator,
  // }) {
  //   return Container(
  //     height: 48,
  //     padding: const EdgeInsets.symmetric(horizontal: 12),
  //     decoration: BoxDecoration(
  //       color: const Color(0xffF5F5F5),
  //       borderRadius: BorderRadius.circular(8),
  //     ),
  //     child: Row(
  //       children: [
  //         if (prefixImage != null) ...[
  //           SvgPicture.asset(
  //             prefixImage,
  //             width: 25,
  //             height: 25,
  //             fit: BoxFit.contain,
  //           ),
  //           const SizedBox(width: 10),
  //         ],
  //         Expanded(
  //           child: DropdownButtonHideUnderline(
  //             child: DropdownButton<String>(
  //               value: value,
  //               isExpanded: true,
  //               icon: const Icon(
  //                 Icons.keyboard_arrow_down_rounded,
  //                 color: Colors.grey,
  //               ),
  //               hint: Text(
  //                 hint,
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                   color: Colors.grey,
  //                 ),
  //               ),
  //               items: items.map((item) {
  //                 return DropdownMenuItem<String>(
  //                   value: item,
  //                   child: Text(item),
  //                 );
  //               }).toList(),
  //               onChanged: onChanged,
  //
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget buildBrandDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    String? prefixImage,
    String? errorText,
  }) {
    // Remove duplicate items
    final uniqueItems = items.toSet().toList();

    // Ensure selected value exists in the list
    final selectedValue =
    (value != null && uniqueItems.contains(value))
        ? value
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xffF5F5F5),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: (errorText != null && errorText.isNotEmpty)
                  ? Colors.red
                  : AppColors.black50,
            ),
          ),
          child: Row(
            children: [
              if (prefixImage != null) ...[
                SvgPicture.asset(
                  prefixImage,
                  width: 25,
                  height: 25,
                ),
                // const SizedBox(width: 10),
              ],
              Expanded(
                child:
                DropdownButtonHideUnderline(
                  child:
                  DropdownButton2<String>(

                    value: selectedValue,
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    items: uniqueItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: onChanged,

                    buttonStyleData: const ButtonStyleData(
                      height: 48,
                      padding: EdgeInsets.zero,
                    ),

                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 48 * 5, // show 5 items

                      // padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,

                      // Opens below the dropdown
                      offset: const Offset(-12, 5),

                      // Prevent clipping in bottom sheet
                      isOverButton: false,
                    ),

                    menuItemStyleData: const MenuItemStyleData(
                      height: 48,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null && errorText.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
  Widget buildDropdown({
    required String hint,
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    String? prefixImage,
    String? errorText,
  }) {
    final uniqueItems = items.toSet().toList();

    // Ensure selected value exists in the list
    final selectedValue =
    (value != null && uniqueItems.contains(value))
        ? value
        : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
              color: Color(0xffF5F5F5),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: (errorText != null && errorText.isNotEmpty)
                    ? Colors.red
                    : AppColors.black50,
              )
          ),
          child: Row(
            children: [
              if (prefixImage != null) ...[
                SvgPicture.asset(
                  prefixImage,
                  width: 25,
                  height: 25,
                ),
                // const SizedBox(width: 10),
              ],
              Expanded(
                child:
                DropdownButtonHideUnderline(
                  child:
                  DropdownButton2<String>(
                    value: selectedValue,
                    isExpanded: true,
                    hint: Text(
                      hint,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),

                    items: uniqueItems.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),

                    onChanged: onChanged,

                    buttonStyleData: const ButtonStyleData(
                      height: 48,
                      padding: EdgeInsets.zero,
                    ),

                    iconStyleData: const IconStyleData(
                      icon: Icon(Icons.keyboard_arrow_down),
                      iconSize: 24,
                    ),

                    dropdownStyleData: DropdownStyleData(
                      maxHeight: 48 * 5, // show 5 items

                      // padding: EdgeInsetsGeometry.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,

                      // Opens below the dropdown
                      offset: const Offset(-12, 5),

                      // Prevent clipping in bottom sheet
                      isOverButton: false,
                    ),

                    menuItemStyleData: const MenuItemStyleData(
                      height: 48,

                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              errorText,
              style:  GoogleFonts.inter(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w600,

              ),
            ),
          ),
      ],
    );
  }
  // Widget _uploadBox({
  //   required String title,
  //   required VoidCallback onTap,
  //   File? image,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: DottedBorder(
  //       color: AppColors.green500,
  //       dashPattern: const [5, 3],
  //       borderType: BorderType.RRect,
  //       radius: const Radius.circular(8),
  //       child: Container(
  //           height: 80,
  //           width: double.infinity,
  //           clipBehavior: Clip.antiAlias,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: image != null
  //               ? Stack(
  //             fit: StackFit.expand,
  //             children: [
  //               Image.file(
  //                 image,
  //                 fit: BoxFit.cover,
  //               ),
  //
  //               Positioned(
  //                 top: 4,
  //                 right: 4,
  //                 child: Container(
  //                   padding: const EdgeInsets.all(2),
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.edit,
  //                     size: 14,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           )
  //               :
  //           title!=""?
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(Images.uploadIcon,height: 30,width: 30),
  //               SizedBox(height: 6),
  //               CustomWidget().buildTextWidget(
  //                 title: title,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w400,
  //                 textColor: AppColors.black400,
  //               ),
  //             ],
  //           ):
  //           Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             children: [
  //               SvgPicture.asset(Images.uploadIcon,height: 30,width: 30),
  //             ],
  //           )
  //
  //       ),
  //     ),
  //   );
  //
  // }
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
                  title==""?
                      Center(child:SvgPicture.asset(Images.uploadIcon)):
                  SvgPicture.asset(Images.uploadIcon),
                   SizedBox(height: title==""?0:6),
                  title==""?SizedBox():
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
                  padding: const EdgeInsets.all(3),
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
  // Widget _uploadBox({
  //   required String title,
  //   required VoidCallback onTap,
  //   File? image,
  //   String? imageUrl,
  //   required VoidCallback onRemove,
  // }) {
  //   return GestureDetector(
  //     onTap: onTap,
  //     child: DottedBorder(
  //       color: AppColors.green500,
  //       dashPattern: const [5, 3],
  //       borderType: BorderType.RRect,
  //       radius: const Radius.circular(8),
  //       child: Container(
  //         height: 80,
  //         width: double.infinity,
  //         clipBehavior: Clip.antiAlias,
  //         decoration: BoxDecoration(
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: image != null ||
  //             (imageUrl != null && imageUrl.isNotEmpty)
  //             ? Stack(
  //           fit: StackFit.expand,
  //           children: [
  //             image != null
  //                 ? Image.file(
  //               image,
  //               fit: BoxFit.cover,
  //             )
  //                 : Image.network(
  //               imageUrl!,
  //               fit: BoxFit.cover,
  //             ),
  //
  //             Positioned(
  //               top: 4,
  //               right: 4,
  //               child: GestureDetector(
  //                 onTap: onRemove,
  //                 child: Container(
  //                   padding: const EdgeInsets.all(2),
  //                   decoration: const BoxDecoration(
  //                     color: Colors.white,
  //                     shape: BoxShape.circle,
  //                   ),
  //                   child: const Icon(
  //                     Icons.edit,
  //                     size: 14,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         )
  //             : Column(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //             SvgPicture.asset(
  //               Images.uploadIcon,
  //               height: 30,
  //               width: 30,
  //             ),
  //             if (title.isNotEmpty) ...[
  //               const SizedBox(height: 6),
  //               CustomWidget().buildTextWidget(
  //                 title: title,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w400,
  //                 textColor: AppColors.black400,
  //               ),
  //             ]
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget _documentSection({
    required String title,
    required Rx<File?> frontImage,
    required Rx<File?> backImage,
    required RxString frontUrl,
    required RxString backUrl,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xffF7F7F7),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              width: 1,
              color: AppColors.black50,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Obx(
                      () => _uploadBox(
                    title: "Front",
                    image: frontImage.value,
                    imageUrl: frontUrl.value,
                    onTap: () =>
                        controller.pickImage(frontImage),
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
                    onTap: () =>
                        controller.pickImage(backImage),
                        onRemove: () {
                          backImage.value = null;
                          backUrl.value = '';
                        },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  // Widget _documentSection({
  //   required String title,
  //   required Rx<File?> frontImage,
  //   required Rx<File?> backImage,
  // }) {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       if (title.isNotEmpty) ...[
  //         CustomWidget().buildTextWidget(
  //           title: title,
  //           fontSize: 14,
  //           fontWeight: FontWeight.w500,
  //           textColor: AppColors.black400,
  //         ),
  //         const SizedBox(height: 10),
  //       ],
  //
  //       Container(
  //         padding: const EdgeInsets.all(12),
  //         decoration: BoxDecoration(
  //             color: const Color(0xffF7F7F7),
  //             borderRadius: BorderRadius.circular(10),
  //             border: Border.all(width: 1,color: AppColors.black50)
  //         ),
  //         child: Row(
  //           children: [
  //             Expanded(
  //               child: Obx(
  //                     () => _uploadBox(
  //                   title: "Front",
  //                   image: frontImage.value,
  //                   onTap: () => controller.pickImage(frontImage),
  //                 ),
  //               ),
  //             ),
  //
  //             const SizedBox(width: 12),
  //
  //             Expanded(
  //               child: Obx(
  //                     () => _uploadBox(
  //                   title: "Back (Optional)",
  //                   image: backImage.value,
  //                   onTap: () => controller.pickImage(backImage),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }

}