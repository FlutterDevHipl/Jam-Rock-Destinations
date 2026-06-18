
import 'package:Jam_Rock_Destinations/Driver/controller/RideHistoryController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/RideDetailScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';

import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class RideHistoryScreen extends StatefulWidget {
  const RideHistoryScreen({super.key});

  @override
  State<RideHistoryScreen> createState() => _RideHistoryScreenState();
}

class _RideHistoryScreenState extends State<RideHistoryScreen> {
  RideHistoryController controller = Get.put(RideHistoryController());
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Obx(
          () => controller.isLoading.value
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.green500))
              : Column(
                  children: [
                    _buildHeader(),
                    const Divider(height: 1),
                    heightSpace20,
                    // Filter Chips
                    SizedBox(
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          _filterChip("All", true),
                          _filterChip("Upcoming", false),
                          _filterChip("Completed", false),
                          _filterChip("Cancelled", false),
                        ],
                      ),
                    ),

                    heightSpace20,
                    Expanded(
                      child: controller.rides.length == 0
                          ? _emptyState()
                          : ListView.builder(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: controller.rides.length,
                              itemBuilder: (context, index) {
                                final ride = controller.rides[index];

                                return GestureDetector(
                                    onTap: () {
                                      Get.to(RideDetailScreen(status: ride["status"] ,));
                                    },
                                    child: _historyListState(ride: ride));
                              },
                            ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

  static Widget _filterChip(String title, bool selected) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? AppColors.yellow50 : AppColors.offWhite,
        borderRadius: BorderRadius.circular(20),
        border: selected ? Border.all(color: AppColors.yellow700) : null,
      ),
      child: CustomWidget().buildTextWidget(
          title: title,
          fontSize: 16,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w400,
          textColor: selected ? AppColors.yellow700 : AppColors.black300),
    );
  }

  static Widget _historyListState({Map<String, dynamic>? ride}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.black50)),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget().buildTextWidget(
                    title: "${ride!["from"]} → ${ride!["to"]}",
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.black400),
                const SizedBox(height: 4),
                CustomWidget().buildTextWidget(
                    title: ride["date"],
                    fontSize: 14,
                    textAlign: TextAlign.center,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black300),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      ride["icon"],
                      size: 14,
                      color: ride["statusColor"],
                    ),
                    const SizedBox(width: 4),
                    CustomWidget().buildTextWidget(
                        title: ride["status"],
                        fontSize: 14,
                        textAlign: TextAlign.center,
                        fontWeight: FontWeight.w400,
                        textColor: ride["statusColor"]),
                  ],
                ),
              ],
            ),
          ),
          Column(
            children: [
              CustomWidget().buildTextWidget(
                  title: ride["amount"],
                  fontSize: 16,
                  textAlign: TextAlign.center,
                  fontWeight: FontWeight.w600,
                  textColor: ride["amountColor"]),
              const SizedBox(height: 20),
              const Icon(
                Icons.chevron_right,
                color: Colors.green,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          Images.rideHistoryEmpty,
          width: 200,
          height: 160,
        ),
        heightSpace10,
        CustomWidget().buildTextWidget(
            title: "No Ride History Found",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 24),
        heightSpace10,
        CustomWidget().buildTextWidget(
            title: "Looks Like you haven't taken any rides yet.",
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
              title: "Ride History",
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
