
import 'package:Jam_Rock_Destinations/Common/ProfileController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../../Utils/app_images.dart';

class RaiseTicketScreen extends StatefulWidget {
  const RaiseTicketScreen({super.key});

  @override
  State<RaiseTicketScreen> createState() => _RaiseTicketScreenState();
}

class _RaiseTicketScreenState extends State<RaiseTicketScreen> {
  final ProfileController controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // controller.getFAQ();
    });
  }

  String? selectedIssue;

  final List<String> issues = [
    "Payment Issue",
    "Booking Issue",
    "Driver Issue",
    "App Issue",
    "Other",
  ];

  final TextEditingController issueController = TextEditingController();

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
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Padding(
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
                                height: 55,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.black50,
                                  ),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: selectedIssue,
                                    hint: Row(
                                      children: [
                                        Icon(
                                          Icons.confirmation_number_outlined,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        SizedBox(width: 10),
                                        CustomWidget().buildTextWidget(
                                            title: "Select Issue Category",
                                            textColor: AppColors.black200,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ],
                                    ),
                                    isExpanded: true,
                                    icon: const Icon(
                                      Icons.keyboard_arrow_down,
                                    ),
                                    items: issues.map((item) {
                                      return DropdownMenuItem(
                                        value: item,
                                        child: Text(item),
                                      );
                                    }).toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        selectedIssue = value;
                                      });
                                    },
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              /// Explain Issue
                              ///
                              CustomWidget().buildTextWidget(
                                  title: "Explain Your Issue",
                                  textColor: AppColors.black300,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14),

                              const SizedBox(height: 10),

                              /// Description Field
                              Container(
                                height: 170,
                                decoration: BoxDecoration(
                                  color: AppColors.offWhite,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: AppColors.black50,
                                  ),
                                ),
                                child: TextFormField(
                                  controller: issueController,
                                  maxLines: null,
                                  expands: true,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: const InputDecoration(
                                    hintText: "Type here....",
                                    hintStyle: TextStyle(
                                      color: Colors.grey,
                                    ),
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 25),

                              /// Info Text
                              Center(
                                child: CustomWidget().buildTextWidget(
                                    title:
                                        "This is a non-real-time ticket system. "
                                        "Our admin team will review and respond "
                                        "to your dashboard log.",
                                    textColor: AppColors.black400,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            // Submit Logic
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade400,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Submit",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
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
