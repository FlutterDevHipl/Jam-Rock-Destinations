import 'package:Jam_Rock_Destinations/Common/controller/LocationController.dart';
import 'package:Jam_Rock_Destinations/Common/notification/NotificationScreen.dart';
import 'package:Jam_Rock_Destinations/Driver/controller/DriverHomeController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/CancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverHomeScreen extends StatefulWidget {
  const DriverHomeScreen({super.key});

  @override
  State<DriverHomeScreen> createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  DriverHomeController controller = Get.put(DriverHomeController());
  Locationcontroller locationcontroller = Get.put(Locationcontroller());

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
                : Stack(
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildHeader(),
                          Expanded(
                              child: GoogleMap(
                            markers: locationcontroller.markers,
                            initialCameraPosition: const CameraPosition(
                              target: Locationcontroller.initialPosition,
                              zoom: 14,
                            ),
                            onMapCreated: (controller) async {
                              locationcontroller.mapController = controller;

                              await locationcontroller.fetchLocation();
                              await locationcontroller.moveToCurrentLocation();
                            },
                            myLocationEnabled: true,
                            myLocationButtonEnabled: false,
                            zoomControlsEnabled: false,
                          )),
                        ],
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                            height: MediaQuery.of(context).size.width * 0.7,
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(8),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: DriverStatusState()),
                      ),
                    ],
                  ),
          ),
        ));
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            Images.logoIcon,
            width: 47,
            height: 45,
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 5,
              vertical: 1,
            ),
            decoration: BoxDecoration(
              color: controller.isOnline.value
                  ? AppColors.green500
                  : AppColors.offWhite,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Visibility(
                  visible: !controller.isOnline.value,
                  child: GestureDetector(
                      onTap: () {
                        controller.isOnline.value = true;
                      },
                      child: SvgPicture.asset(Images.offlineToggle)),
                ),
                widthSpace3,
                CustomWidget().buildTextWidget(
                    title: "Offline",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: controller.isOnline.value
                        ? AppColors.whiteColor
                        : AppColors.black400,
                    textAlign: TextAlign.center),
                widthSpace3,
                Visibility(
                    visible: controller.isOnline.value,
                    child: GestureDetector(
                        onTap: () {
                          controller.isOnline.value = false;
                        },
                        child: SvgPicture.asset(Images.onlineToggle))),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Get.to(NotificationScreen());
            },
            child: Stack(
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
          ),
        ],
      ),
    );
  }
}

class DriverStatusState extends StatelessWidget {
  DriverStatusState({super.key});

  DriverHomeController controller = Get.put(DriverHomeController());

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SvgPicture.asset(Images.wallet_Icon),
                widthSpace8,
                CustomWidget().buildTextWidget(
                    title: "Today's Earnings",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black500,
                    textAlign: TextAlign.center),
              ],
            ),
            CustomWidget().buildTextWidget(
                title: "\$500",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                textColor: AppColors.black500,
                textAlign: TextAlign.center),
          ],
        ),
        heightSpace24,
        SvgPicture.asset(
          controller.isOnline.value ? Images.online : Images.offline,
        ),
        heightSpace15,
        CustomWidget().buildTextWidget(
            title:
                controller.isOnline.value ? "You're online" : "You're offline",
            fontSize: 18,
            fontWeight: FontWeight.w700,
            textColor: AppColors.black500,
            textAlign: TextAlign.center),
        heightSpace8,
        CustomWidget().buildTextWidget(
            title: controller.isOnline.value
                ? "Waiting for ride requests..."
                : "Turn on Drive Mode to \nstart receiving requests",
            fontSize: 16,
            fontWeight: FontWeight.w400,
            textColor: AppColors.black400,
            textAlign: TextAlign.center),
      ],
    );
  }
}

class RideRequestSheet extends StatelessWidget {
  const RideRequestSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.4,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomWidget().buildTextWidget(
                      title: "New Ride Request",
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black400,
                      textAlign: TextAlign.center),
                  heightSpace4,
                  CustomWidget().buildTextWidget(
                      title: "\$800",
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                      textColor: AppColors.black500,
                      textAlign: TextAlign.center),
                ],
              ),
              Spacer(),
              SvgPicture.asset(Images.cross_square)
            ],
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150",
              ),
            ),
            title: CustomWidget().buildTextWidget(
                title: "Peter parker",
                fontSize: 16,
                fontWeight: FontWeight.w600,
                textColor: AppColors.black500,
                textAlign: TextAlign.start),
          ),
          heightSpace12,
          const LocationRow(
            iconColor: Colors.green,
            title: "Pickup Location",
            subtitle: "4.1 km away",
          ),
          const SizedBox(height: 12),
          const LocationRow(
            iconColor: Colors.amber,
            title: "Destination",
            subtitle: "8.2 km ride",
          ),
          const Spacer(),
          Container(
            width: Get.width,
            decoration: BoxDecoration(
                color: AppColors.green500,
                borderRadius: BorderRadius.circular(8)),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                SvgPicture.asset(Images.slideIcon),
                Container(
                  width: Get.width,
                  child: CustomWidget().buildTextWidget(
                      title: "Slide To Accept Ride",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.whiteColor,
                      textAlign: TextAlign.center),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class OngoingRideSheet extends StatelessWidget {
  const OngoingRideSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomWidget().buildTextWidget(
                    title: "Ongoing Ride",
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    textColor: AppColors.green500,
                    textAlign: TextAlign.center),
                heightSpace4,
                CustomWidget().buildTextWidget(
                    title: "\$800",
                    fontSize: 32,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.black500,
                    textAlign: TextAlign.center),
              ],
            ),
            Spacer(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CustomWidget().buildTextWidget(
                    title: "Arriving pickup point in",
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.black400,
                    textAlign: TextAlign.center),
                heightSpace4,
                Container(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColors.green500),
                  child: CustomWidget().buildTextWidget(
                      title: "6 Min",
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.whiteColor,
                      textAlign: TextAlign.center),
                )
              ],
            ),
          ],
        ),
        const Divider(),
        ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const CircleAvatar(
              backgroundImage: NetworkImage(
                "https://i.pravatar.cc/150",
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidget().buildTextWidget(
                    title: "Peter parker",
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    textColor: AppColors.black500,
                    textAlign: TextAlign.start),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColors.green50),
                    child: Row(
                      children: [
                        Icon(
                          Icons.call,
                          color: AppColors.green500,
                        ),
                        widthSpace5,
                        CustomWidget().buildTextWidget(
                            title: "Call",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            textColor: AppColors.green500,
                            textAlign: TextAlign.center),
                        widthSpace5,
                      ],
                    ))
              ],
            )),
        heightSpace12,
        const LocationRow(
          iconColor: Colors.green,
          title: "Pickup Location",
          subtitle: "4.1 km away",
        ),
        const SizedBox(height: 12),
        const LocationRow(
          iconColor: Colors.amber,
          title: "Destination",
          subtitle: "8.2 km ride",
        ),
        const Spacer(),
        Container(
          width: Get.width,
          decoration: BoxDecoration(
              color: AppColors.green500,
              borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              SvgPicture.asset(Images.slideIcon),
              widthSpace10,
              CustomWidget().buildTextWidget(
                  title: "Slide To Confirm Your Arrival",
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.whiteColor,
                  textAlign: TextAlign.center)
            ],
          ),
        ),
        heightSpace10,
        CustomWidget().buildOutlinedBtn(
          text: "Cancel Ride",
          btBorderColor: AppColors.redColor400,
          fontSize: 16,
          radius: 8,
          textColor: AppColors.redColor400,
          onPressed: () {
            Get.to(CancelRideScreen());
          },
        )
      ],
    );
  }
}

class LocationRow extends StatelessWidget {
  final Color iconColor;
  final String title;
  final String subtitle;

  const LocationRow({
    super.key,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: iconColor,
              width: 2,
            ),
          ),
          child: Center(
            child: CircleAvatar(
              radius: 4,
              backgroundColor: iconColor,
            ),
          ),
        ),

        // Icon(
        //   Icons.location_on,
        //   color: iconColor,
        //   size: 20,
        // ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: title,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.black500,
                  textAlign: TextAlign.start),
              CustomWidget().buildTextWidget(
                  title: subtitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  textColor: AppColors.black300,
                  textAlign: TextAlign.start),
            ],
          ),
        )
      ],
    );
  }
}
