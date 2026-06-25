import 'package:Jam_Rock_Destinations/Driver/controller/EarningController.dart';
import 'package:Jam_Rock_Destinations/Driver/controller/RideHistoryController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/RideDetailScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';

import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class EarningScreen extends StatefulWidget {
  const EarningScreen({super.key});

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  EarningController controller = Get.put(EarningController());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("Karishma Imageapdsfsdjfpo");
    print(Images.empty_earning);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const Divider(height: 1),
                    heightSpace20,
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: AppColors.offWhite,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  controller.isDailyTabClick.value = true;
                                  controller.isMonthlyTabClick.value = false;
                                  controller.isWeeklyTabClick.value = false;
                                },
                                child: _tab(
                                    "Daily", controller.isDailyTabClick.value)),
                          ),
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  controller.isDailyTabClick.value = false;
                                  controller.isMonthlyTabClick.value = false;
                                  controller.isWeeklyTabClick.value = true;
                                },
                                child: _tab("Weekly",
                                    controller.isWeeklyTabClick.value)),
                          ),
                          Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  controller.isDailyTabClick.value = false;
                                  controller.isMonthlyTabClick.value = true;
                                  controller.isWeeklyTabClick.value = false;
                                },
                                child: _tab("Monthly",
                                    controller.isMonthlyTabClick.value)),
                          ),
                        ],
                      ),
                    ),
                    heightSpace20,

                    // Expanded(child: _emptyState()),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomWidget().buildTextWidget(
                                      title: controller.isDailyTabClick.value
                                          ? "Today's Earnings"
                                          : "Weekly Earnings",
                                      textColor: AppColors.black300,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                  Row(
                                    children: [
                                      // SvgPicture.asset(Images.calender),
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 14,
                                        color: Colors.green,
                                      ),
                                      widthSpace5,
                                      CustomWidget().buildTextWidget(
                                          title: "Next payout: 1 Jun",
                                          textColor: AppColors.black400,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ],
                                  ),
                                ],
                              ),
                              heightSpace5,
                              CustomWidget().buildTextWidget(
                                  title: "\$1,180",
                                  textAlign: TextAlign.start,
                                  textColor: AppColors.green500,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 28),
                              heightSpace20,
                              
                              SizedBox(
                                // height: 120,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      children: List.generate(
                                        controller.earningsData.length,
                                        (index) => Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 5, horizontal: 5),
                                              child: CustomWidget().buildTextWidget(
                                                  title:
                                                      "\$${controller.earningsData[index]}",
                                                  textAlign: TextAlign.start,
                                                  textColor: AppColors.black300,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    heightSpace5,
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: List.generate(
                                          controller.earningsData.length,
                                          (index) => Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: 12,
                                                height: controller
                                                        .earningsData[index] /
                                                    12,
                                                decoration: BoxDecoration(
                                                    color: AppColors.green300,
                                                    border: Border.all(
                                                        color:
                                                            AppColors.green300),
                                                    // borderRadius: BorderRadius.circular(4),
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft:
                                                                Radius.circular(
                                                                    4),
                                                            topRight: Radius
                                                                .circular(4))),
                                              ),
                                              if (index !=
                                                  controller
                                                          .earningsData.length -
                                                      1)
                                                Container(
                                                  // width: Get.width,
                                                  width: 57,
                                                  height: 1,
                                                  color: AppColors.green300,
                                                ),
                                              heightSpace8,
                                              CustomWidget().buildTextWidget(
                                                  title:
                                                      "${index + 9 > 12 ? index - 3 : index + 9}",
                                                  textAlign: TextAlign.start,
                                                  textColor: AppColors.black300,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 10)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              heightSpace20,
                              Row(
                                children: [
                                  Expanded(
                                    child: _statCard(
                                      title: "Total Ride",
                                      value: "24",
                                      icon: Icons.directions_car,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _statCard(
                                      title: "Online Hours",
                                      value: "6.5h",
                                      icon: Icons.access_time,
                                    ),
                                  ),
                                ],
                              ),
                              heightSpace20,
                              CustomWidget().buildTextWidget(
                                  title: "Breakdown",
                                  textAlign: TextAlign.start,
                                  textColor: AppColors.black500,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18),
                              heightSpace15,
                              _breakdownRow(
                                "Ride Earnings",
                                "\$1,380",
                                valueColor: AppColors.black400,
                                titleColor: AppColors.black400,
                              ),
                              _breakdownRow(
                                "Platform Fee",
                                "-\$200",
                                valueColor: AppColors.redColor400,
                                titleColor: AppColors.redColor400,
                              ),
                              _breakdownRow(
                                "Net Earnings",
                                "\$1,180",
                                isBold: true,
                                valueColor: AppColors.black500,
                                titleColor: AppColors.black500,
                              ),
                              heightSpace10,
                              Divider(
                                color: AppColors.black50,
                              ),
                              heightSpace5,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  CustomWidget().buildTextWidget(
                                      title: "Ride History",
                                      textAlign: TextAlign.start,
                                      textColor: AppColors.black500,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18),
                                  TextButton(
                                    onPressed: () {},
                                    child: CustomWidget().buildTextWidget(
                                        title: "See All",
                                        textAlign: TextAlign.start,
                                        textColor: AppColors.green500,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18),
                                  )
                                ],
                              ),
                              heightSpace10,
                              SizedBox(
                                height: 350,
                                child: ListView.builder(
                                  itemCount: 5,
                                  itemBuilder: (context, index) {
                                    return _rideCard(
                                        // amount: "+\$100",
                                        // amountColor: Colors.black87,
                                        // status: "Completed",
                                        // statusColor: Colors.green,
                                        amount: "+\$100",
                                        dateTime: "10:11 AM, 23 May 2026",
                                        isCompleted: true,
                                        route: "Kingston → Montage Bay");
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  Widget _rideCard({
    required String route,
    required String dateTime,
    required String amount,
    required bool isCompleted,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.black50,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Route
                CustomWidget().buildTextWidget(
                    title: route,
                    textAlign: TextAlign.start,
                    textColor: AppColors.black400,
                    fontWeight: FontWeight.w600,
                    fontSize: 14),

                heightSpace5,

                /// Date
                CustomWidget().buildTextWidget(
                    title: dateTime,
                    textAlign: TextAlign.start,
                    textColor: AppColors.black300,
                    fontWeight: FontWeight.w400,
                    fontSize: 14),

                const SizedBox(height: 8),

                /// Status
                Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_outline
                          : Icons.cancel_outlined,
                      size: 18,
                      color: isCompleted
                          ? const Color(0xFF2E9B4D)
                          : const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(width: 4),
                    CustomWidget().buildTextWidget(
                        title: isCompleted ? "Completed" : "Cancelled",
                        textAlign: TextAlign.start,
                        textColor: isCompleted
                            ? AppColors.green500
                            : AppColors.redColor400,
                        fontWeight: FontWeight.w400,
                        fontSize: 14),
                  ],
                ),
              ],
            ),
          ),

          /// Right Side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CustomWidget().buildTextWidget(
                  title: amount,
                  textAlign: TextAlign.start,
                  textColor: amount.startsWith("-")
                      ? AppColors.redColor400
                      : AppColors.black400,
                  fontWeight: FontWeight.w600,
                  fontSize: 16),
              heightSpace20,
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF2E9B4D),
                size: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _breakdownRow(
    String title,
    String value, {
    Color valueColor = AppColors.black500,
    Color titleColor = AppColors.black500,
    bool isBold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomWidget().buildTextWidget(
              title: title,
              textAlign: TextAlign.start,
              textColor: titleColor,
              fontWeight: FontWeight.w400,
              fontSize: 14),
          CustomWidget().buildTextWidget(
              title: title,
              textAlign: TextAlign.start,
              textColor: valueColor,
              fontWeight: FontWeight.w400,
              fontSize: 14),
        ],
      ),
    );
  }

  static Widget _statCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: AppColors.black50),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget().buildTextWidget(
                    title: title,
                    textAlign: TextAlign.start,
                    textColor: AppColors.black400,
                    fontWeight: FontWeight.w500,
                    fontSize: 14),
                heightSpace5,
                CustomWidget().buildTextWidget(
                    title: value,
                    textAlign: TextAlign.start,
                    textColor: AppColors.black500,
                    fontWeight: FontWeight.w600,
                    fontSize: 16),
              ],
            ),
          ),
          CircleAvatar(
            backgroundColor: Colors.green.shade50,
            child: Icon(
              icon,
              color: Colors.green,
            ),
          )
        ],
      ),
    );
  }

  Widget _tab(String title, bool selected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
      ),
      child: CustomWidget().buildTextWidget(
          title: title,
          textAlign: TextAlign.center,
          textColor: selected ? AppColors.black500 : AppColors.black200,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 16),
    );
  }

  static Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          Images.emptyEarning,
          width: 200,
          height: 160,
          errorBuilder: (context, error, stackTrace) {
            print('ERROR: $error');
            return const Text('Image not found');
          },
        ),
        heightSpace10,
        CustomWidget().buildTextWidget(
            title: "No Earning History",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 24),
        heightSpace10,
        CustomWidget().buildTextWidget(
            title: "Looks Like you haven't earned anything yet.",
            textColor: AppColors.black400,
            fontWeight: FontWeight.w400,
            fontSize: 16),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: CustomWidget().buildTextWidget(
              title: "Earnings",
              fontSize: 24,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500,
            ),
          ),
          Stack(
            alignment: Alignment.topRight,
            children: [
              const Icon(Icons.notifications_outlined, size: 25),
              Positioned(
                // right: 10,
                bottom: 8,
                // top: 4,
                child: Container(
                  // height: 8,
                  // width: 8,
                  padding: EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: CustomWidget().buildTextWidget(
                      title: "2",
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.whiteColor,
                      textAlign: TextAlign.center),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
