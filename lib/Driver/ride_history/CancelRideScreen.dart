import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/RideHistoryController.dart';

class CancelRideScreen extends StatefulWidget {
  CancelRideScreen({
    super.key,
  });

  @override
  State<CancelRideScreen> createState() => _CancelRideScreenState();
}

class _CancelRideScreenState extends State<CancelRideScreen> {
  RideHistoryController controller = Get.put(RideHistoryController());
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
              title: "Cancel Ride",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      heightSpace20,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomWidget().buildTextWidget(
                            title: "Are you sure you want to cancel this ride?",
                            textColor: AppColors.black500,
                            fontWeight: FontWeight.w700,
                            // textAlign: TextAlign.center,
                            fontSize: 18),
                      ),
                      heightSpace10,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: CustomWidget().buildTextWidget(
                            title: "Cancellation charges may apply."
                                "Please review our Cancellation Policy before proceeding.",
                            textColor: AppColors.black400,
                            fontWeight: FontWeight.w400,
                            // textAlign: TextAlign.center,
                            fontSize: 16),
                      ),
                      heightSpace15,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Divider(
                          color: AppColors.black50,
                        ),
                      ),
                      heightSpace20,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomWidget().buildTextWidget(
                            title: "Reason for cancellation",
                            textColor: AppColors.black500,
                            fontWeight: FontWeight.w700,
                            // textAlign: TextAlign.center,
                            fontSize: 18),
                      ),
                      heightSpace20,
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.reasons.length,
                          itemBuilder: (context, index) {
                            return RadioListTile<String>(
                              // contentPadding: EdgeInsets.zero,
                              value: controller.reasons[index],
                              groupValue: controller.selectedReason,
                              activeColor: Colors.green,
                              title: CustomWidget().buildTextWidget(
                                  title: controller.reasons[index],
                                  textColor: AppColors.black400,
                                  fontWeight: FontWeight.w400,
                                  // textAlign: TextAlign.center,
                                  fontSize: 16),
                              onChanged: (value) {
                                setState(() {
                                  controller.selectedReason = value!;
                                });
                              },
                            );
                          }),
                      heightSpace20,
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomWidget().buildTextFormField(
                              darkMode: false,
                              filled: true,
                              maxLines: 5,
                              hintText: "Tell us more...",
                              radius: 8)),
                      heightSpace50,
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomWidget().buildMaterialBtn(
                              radius: 8,
                              text: "Yes, Cancel Ride",
                              onPressed: () {},
                              color: AppColors.redColor400)),
                      heightSpace10,
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomWidget().buildOutlinedBtn(
                              radius: 8,
                              text: "Keep my Ride",
                              onPressed: () {},
                              btBorderColor: AppColors.black400,
                              textColor: AppColors.black400))
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _completedData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Distance Charge",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "\$1000",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
            ],
          ),
        ),
        heightSpace5,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Platform Fee",
                  textColor: AppColors.redColor400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "-\$200",
                  textColor: AppColors.redColor400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
            ],
          ),
        ),
        heightSpace5,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Net Earning",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
              CustomWidget().buildTextWidget(
                  title: "\$800",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget _upcomingData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Distance Charge",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "\$1000",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
            ],
          ),
        ),
        heightSpace15,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomWidget().buildTextWidget(
              title: "Net Earnings credited after trip completion.",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w500,
              textAlign: TextAlign.center,
              fontSize: 16),
        ),
        // Spacer(),
      ],
    );
  }

  Widget _cancelledData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: CustomWidget().buildTextWidget(
              title: "Wrong location entered",
              textColor: AppColors.black400,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
              fontSize: 14),
        ),
        heightSpace15,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Divider(
            color: AppColors.black50,
          ),
        ),
        heightSpace10,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: CustomWidget().buildTextWidget(
              title: "Earnings",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              // textAlign: TextAlign.center,
              fontSize: 18),
        ),
        heightSpace10,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Cancelation Charge",
                  textColor: AppColors.redColor400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "-\$20",
                  textColor: AppColors.redColor400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
            ],
          ),
        ),
        heightSpace5,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Net Earning",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
              CustomWidget().buildTextWidget(
                  title: "-\$20",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
            ],
          ),
        ),
      ],
    );
  }
}
