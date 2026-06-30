import 'package:Jam_Rock_Destinations/Common/Controller/RaiseTickitController.dart';
import 'package:Jam_Rock_Destinations/Common/ProfileController/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:google_fonts/google_fonts.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final ProfileController controller = Get.put(ProfileController());
  final RaiseTickitcontroller raiseTickitcontroller =
      Get.put(RaiseTickitcontroller());

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            title: "Raise Ticket",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Obx(
              () {
                return CustomWidget().buildMaterialBtn(
                  color: raiseTickitcontroller.isFormValid.value
                      ? AppColors.green500
                      : AppColors.black100,
                  // isSaveEnabled ? AppColors.green500 : AppColors.black100,
                  radius: 8,
                  height: 50,
                  minWidth: double.maxFinite,
                  textColor: Colors.white,
                  text: raiseTickitcontroller.isLoading.value
                      ? "Loading..."
                      : "Submit",
                  onPressed: () {
                    raiseTickitcontroller.isFormValid.value
                        ? raiseTickitcontroller.raiseTickit()
                        : null;
                  },
                );
              },
            )),
      ),
      body: SafeArea(
        child: Obx(
          () => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Form
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// Category Title

                        CustomWidget().buildTextWidget(
                            title: "Select Issue Category",
                            textColor: AppColors.black300,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),

                        const SizedBox(height: 10),

                        /// Dropdown

                        Container(
                          height: 48,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: AppColors.offWhite,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: AppColors.black50,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.confirmation_number_outlined,
                                size: 20,
                                color: Colors.grey,
                              ),
                              widthSpace3,
                              Expanded(
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton2<String>(
                                    value: raiseTickitcontroller
                                        .selectedIssue.value,
                                    isExpanded: true,
                                    hint: CustomWidget().buildTextWidget(
                                        title: "Select an issue",
                                        textColor: AppColors.black200,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16),
                                    items: raiseTickitcontroller.issues
                                        .map((item) {
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
                                    onChanged: (value) {
                                      raiseTickitcontroller
                                          .selectedIssue.value = value!;
                                    },
                                    buttonStyleData: const ButtonStyleData(
                                      height: 48,
                                      padding: EdgeInsets.zero,
                                    ),
                                    iconStyleData: const IconStyleData(
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      iconSize: 24,
                                    ),
                                    menuItemStyleData: const MenuItemStyleData(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 16),
                                    ),
                                    dropdownStyleData: DropdownStyleData(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          border: Border.all(
                                              color: AppColors.black50,
                                              width: 1)),
                                      elevation: 4,

                                      // Opens below the dropdown
                                      offset: const Offset(-35, 0),
                                      width: Get.width - 35,
                                      // Prevent clipping in bottom sheet
                                      isOverButton: false,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        heightSpace25,

                        /// Explain Issue

                        CustomWidget().buildTextWidget(
                            title: "Explain Your Issue",
                            textColor: AppColors.black300,
                            fontWeight: FontWeight.w600,
                            fontSize: 14),

                        const SizedBox(height: 10),

                        /// Description Field
                        CustomWidget().buildTextFormField(
                            filled: true,
                            color: AppColors.offWhite,
                            darkMode: false,
                            controller: raiseTickitcontroller.issueController,
                            hintText: "Type here....",
                            maxLines: 7,
                            radius: 8),

                        const SizedBox(height: 25),

                        /// Info Text
                        CustomWidget().buildTextWidget(
                            title: "This is a non-real-time ticket system. Our admin team will review and respond to your dashboard log.",
                            textColor: AppColors.black400,
                            textAlign: TextAlign.center,
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
