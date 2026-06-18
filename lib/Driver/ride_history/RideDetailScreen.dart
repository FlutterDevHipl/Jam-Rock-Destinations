import 'package:Jam_Rock_Destinations/Driver/ride_history/CancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../controller/RideHistoryController.dart';

class RideDetailScreen extends StatefulWidget {
  String status;
  RideDetailScreen({super.key, required this.status});

  @override
  State<RideDetailScreen> createState() => _RideDetailScreenState();
}

class _RideDetailScreenState extends State<RideDetailScreen> {
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
              title: "Ride Details",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 20)),
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpace20,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget().buildTextWidget(
                              title: "Ride Info",
                              textColor: AppColors.black500,
                              fontWeight: FontWeight.w700,
                              textAlign: TextAlign.center,
                              fontSize: 18),
                          widget.status == "Completed"
                              ? CustomWidget().buildTextWidget(
                                  title: "12 km, 29 mins",
                                  textColor: AppColors.black400,
                                  fontWeight: FontWeight.w500,
                                  textAlign: TextAlign.center,
                                  fontSize: 16)
                              : widget.status == "Cancelled"
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.cancel_outlined,
                                          color: AppColors.redColor400,
                                          size: 18,
                                        ),
                                        SizedBox(width: 4),
                                        CustomWidget().buildTextWidget(
                                            title: "Cancelled",
                                            textColor: AppColors.redColor400,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                            fontSize: 14),
                                      ],
                                    )
                                  : Row(
                                      children: [
                                        SvgPicture.asset(
                                          Images.clock,
                                          color: AppColors.amberColor,
                                        ),
                                        SizedBox(width: 4),
                                        CustomWidget().buildTextWidget(
                                            title: "Upcoming",
                                            textColor: AppColors.amberColor,
                                            fontWeight: FontWeight.w400,
                                            textAlign: TextAlign.center,
                                            fontSize: 14),
                                      ],
                                    )
                        ],
                      ),
                    ),

                    heightSpace10,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomWidget().buildTextWidget(
                              title: "10:11 AM, 23 May 2026",
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w400,
                              textAlign: TextAlign.center,
                              fontSize: 14),
                          Visibility(
                            visible: widget.status == "Completed",
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: Colors.green,
                                  size: 18,
                                ),
                                SizedBox(width: 4),
                                CustomWidget().buildTextWidget(
                                    title: "Completed",
                                    textColor: AppColors.green500,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    fontSize: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    heightSpace15,

                    /// Pickup
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.green,
                                  ),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade400,
                              ),
                              // Image.asset(Images.dottedLine, height: 33,)
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidget().buildTextWidget(
                                    title: "Kingston Montage Bay",
                                    textColor: AppColors.black500,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.center,
                                    fontSize: 14),
                                heightSpace5,
                                CustomWidget().buildTextWidget(
                                    title: "Ocho Rios, Jamaica",
                                    textColor: AppColors.black300,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    fontSize: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.amber,
                                    width: 2,
                                  ),
                                ),
                                child: const Center(
                                  child: CircleAvatar(
                                    radius: 4,
                                    backgroundColor: Colors.amber,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidget().buildTextWidget(
                                    title: "Kingston Montage Bay",
                                    textColor: AppColors.black500,
                                    fontWeight: FontWeight.w500,
                                    textAlign: TextAlign.center,
                                    fontSize: 14),
                                heightSpace5,
                                CustomWidget().buildTextWidget(
                                    title: "Ocho Rios, Jamaica",
                                    textColor: AppColors.black300,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    fontSize: 14),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Balance / Amount Display
                    Center(
                      child: CustomWidget().buildTextWidget(
                          title: '',
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w600,
                          textAlign: TextAlign.center,
                          fontSize: 28),
                    ),
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
                          title: widget.status == "Cancelled"
                              ? "Reason"
                              : "Earnings",
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w700,
                          // textAlign: TextAlign.center,
                          fontSize: 18),
                    ),
                    heightSpace20,
                    if (widget.status == "Completed") _completedData(),
                    if (widget.status == "Cancelled") _cancelledData(),
                    if (widget.status == "Upcoming") _upcomingData(),

                    Spacer(),
                    if (widget.status == "Upcoming")
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: CustomWidget().buildMaterialBtn(
                              radius: 8,
                              text: "Cancel Ride",
                              onPressed: () {
                                Get.to(CancelRideScreen());
                              },
                              color: AppColors.redColor400))
                  ],
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
