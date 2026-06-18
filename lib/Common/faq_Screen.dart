
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import 'ProfileController.dart';

class FAQScreen extends StatefulWidget {

  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {

  final ProfileController  controller = Get.put(ProfileController());
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFAQ();
    });


  }
  int expandedIndex = 0;

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
        title: const Text(
          "FAQs",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(
            () =>
        controller.isLoading.value?
        CircularProgressIndicator(backgroundColor: AppColors.green500):
        ListView.separated(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          itemCount: controller.faq.length,
          separatorBuilder: (context, index) =>
          const Divider(height: 1, color: AppColors.black50),
          itemBuilder: (context, index) {
            final faq = controller.faq[index];

            return Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                key: Key(index.toString()),
                initiallyExpanded: expandedIndex == index,
                tilePadding: EdgeInsets.zero,
                childrenPadding: EdgeInsets.zero,
                iconColor: Colors.green,
                collapsedIconColor: Colors.green,
                title:
                CustomWidget().buildTextWidget(title: faq["question"] ?? "",fontSize: 16,textColor: expandedIndex == index?AppColors.green500:AppColors.black500,fontWeight: FontWeight.w500),
                onExpansionChanged: (isExpanded) {
                  setState(() {
                    expandedIndex = isExpanded ? index : -1;
                  });
                },
                children: [
                  Padding(
                      padding: const EdgeInsets.only(
                        right: 20,
                        bottom: 15,
                      ),
                      child:
                      CustomWidget().buildTextWidget(title:  faq["answer"] ?? "",textColor: AppColors.black300,fontSize: 14,fontWeight: FontWeight.w400)

                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}