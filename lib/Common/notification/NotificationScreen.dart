import 'package:Jam_Rock_Destinations/Customer/booking/BookingCancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/BookingController.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/HomeController.dart';
import 'package:Jam_Rock_Destinations/Common/controller/NotificationController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/CancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatefulWidget {
  NotificationScreen({
    super.key,
  });

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationController controller = Get.put(NotificationController());

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
            title: "Notifications",
            textColor: AppColors.black500,
            fontWeight: FontWeight.w700,
            fontSize: 20),
      ),
      body: SafeArea(
        child: Obx(() => !controller.internetStatus.value
            ? CustomWidget().customNetWorkWidget()
            : controller.isLoading.value
                ? Center(
                    child: CircularProgressIndicator(color: AppColors.green500))
                : controller.notificationList.length == 0
                    ? _emptyState()
                    : ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: controller.notificationList.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final item = controller.notificationList[index];

                          return NotificationTile(
                            title: item["title"]!,
                            message: item["message"]!,
                            time: item["time"]!,
                          );
                        },
                      )),
      ),
    );
  }

  static Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Images.emptyNotification,
            width: 150,
            height: 150,
          ),
          // Image.asset(Images.emptyNotification),
          heightSpace10,
          CustomWidget().buildTextWidget(
              title: "No Notifications Yet",
              textColor: AppColors.black500,
              fontWeight: FontWeight.w700,
              fontSize: 24),
          heightSpace10,
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: CustomWidget().buildTextWidget(
                title:
                    "Notifications will appear here when you receive updates.",
                textColor: AppColors.black400,
                fontWeight: FontWeight.w400,
                textAlign: TextAlign.center,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    double distance = 150;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(8),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget().buildTextWidget(
                        title: "Filter",
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        textColor: AppColors.black500,
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.close,
                          color: AppColors.green500,
                        ),
                      ),
                    ],
                  ),

                  heightSpace20,
                  CustomWidget().buildTextWidget(
                    title: "Select Distance",
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.black500,
                  ),
                  heightSpace15,
                  CustomWidget().buildTextWidget(
                    title: "${distance.toInt()}km",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.fourthColor,
                  ),

                  Slider(
                    value: distance,
                    min: 0,
                    max: 400,
                    activeColor: Colors.green,
                    onChanged: (value) {
                      setState(() {
                        distance = value;
                      });
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomWidget().buildTextWidget(
                        title: "0km",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.green500,
                      ),
                      CustomWidget().buildTextWidget(
                        title: "400km",
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        textColor: AppColors.green500,
                      ),
                    ],
                  ),

                  heightSpace25,

                  SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                            child: CustomWidget().buildOutlinedBtn(
                          text: "Reset",
                          btBorderColor: AppColors.green500,
                          fontSize: 16,
                          radius: 8,
                          textColor: AppColors.green500,
                          onPressed: () {
                            setState(() {
                              distance = 0;
                            });
                          },
                        )),
                        const SizedBox(width: 12),
                        Expanded(
                            child: CustomWidget().buildMaterialBtn(
                          text: "Reset",
                          color: AppColors.green500,
                          fontSize: 16,
                          radius: 8,
                          textColor: AppColors.whiteColor,
                          onPressed: () {
                            setState(() {
                              distance = 0;
                            });
                          },
                        )),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class NotificationTile extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  const NotificationTile({
    super.key,
    required this.title,
    required this.message,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(Images.bookingConfirmedIcon),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                title: title,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.black500,
              ),
              const SizedBox(height: 4),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: message,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.black300,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              CustomWidget().buildTextWidget(
                title: time,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                textColor: AppColors.black300,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
