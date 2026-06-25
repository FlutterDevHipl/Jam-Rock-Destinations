import 'package:Jam_Rock_Destinations/Customer/booking/BookingCancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Customer/controller/BookingController.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/CancelRideScreen.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BookingRideDetailScreen extends StatefulWidget {
  String status;
  BookingRideDetailScreen({super.key, required this.status});

  @override
  State<BookingRideDetailScreen> createState() =>
      _BookingRideDetailScreenState();
}

class _BookingRideDetailScreenState extends State<BookingRideDetailScreen> {
  BookingController controller = Get.put(BookingController());
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
              : ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    heightSpace20,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomWidget().buildTextWidget(
                                    title: "Taxi Ride",
                                    fontSize: 16,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppColors.black400),
                                heightSpace5,
                                CustomWidget().buildTextWidget(
                                    title: "10:11 AM, 23 May 2026",
                                    fontSize: 14,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w400,
                                    textColor: AppColors.black300),
                                heightSpace5,
                                CustomWidget().buildTextWidget(
                                    title: "\$1150",
                                    fontSize: 16,
                                    textAlign: TextAlign.start,
                                    fontWeight: FontWeight.w600,
                                    textColor: AppColors.black500),
                              ],
                            ),
                          ),
                          SvgPicture.asset(Images.carpreview),
                        ],
                      ),
                    ),

                    heightSpace5,

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            widget.status == "Completed"
                                ? Images.check_circle
                                : widget.status == "Cancelled"
                                    ? Images.cancelIcon
                                    : Images.clockIcon,
                            color: widget.status == "Completed"
                                ? AppColors.green500
                                : widget.status == "Cancelled"
                                    ? AppColors.redColor400
                                    : AppColors.amberColor,
                          ),
                          const SizedBox(width: 4),
                          CustomWidget().buildTextWidget(
                              title: widget.status,
                              fontSize: 14,
                              textAlign: TextAlign.center,
                              fontWeight: FontWeight.w400,
                              textColor: widget.status == "Completed"
                                  ? AppColors.green500
                                  : widget.status == "Cancelled"
                                      ? AppColors.redColor400
                                      : AppColors.amberColor),
                          Spacer(),
                          CustomWidget().buildTextWidget(
                              title: "Suzuki R  7790 HD",
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w600,
                              textAlign: TextAlign.center,
                              fontSize: 14),
                        ],
                      ),
                    ),

                    if (widget.status == "Cancelled")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12.0, vertical: 20),
                            child: Divider(
                              color: AppColors.black50,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: CustomWidget().buildTextWidget(
                                  title: "Reason",
                                  textColor: AppColors.black500,
                                  fontWeight: FontWeight.w700,
                                  textAlign: TextAlign.center,
                                  fontSize: 18)),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 5),
                              child: CustomWidget().buildTextWidget(
                                  title: "Wrong location entered",
                                  textColor: AppColors.black400,
                                  fontWeight: FontWeight.w400,
                                  textAlign: TextAlign.center,
                                  fontSize: 14)),
                        ],
                      ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12.0, vertical: 10),
                      child: Divider(
                        color: AppColors.black50,
                      ),
                    ),
                    // heightSpace10,
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
                          CustomWidget().buildTextWidget(
                              title: "12 km, 29 mins",
                              textColor: AppColors.black400,
                              fontWeight: FontWeight.w500,
                              textAlign: TextAlign.center,
                              fontSize: 16)
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
                    heightSpace20,

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
                              ? "Refund Summary"
                              : "Invoice",
                          textColor: AppColors.black500,
                          fontWeight: FontWeight.w700,
                          // textAlign: TextAlign.center,
                          fontSize: 18),
                    ),
                    heightSpace20,
                    if (widget.status == "Completed") _completedData(),
                    if (widget.status == "Cancelled") _cancelledData(),
                    if (widget.status == "Pre-Booked") _preBookedData(),

                    // Spacer(),

                    heightSpace20,
                    if (widget.status == "Completed")
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      border:
                                          Border.all(color: AppColors.green500),
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.whiteColor),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Images.helpIcon,
                                        color: AppColors.green500,
                                        width: 15,
                                        height: 15,
                                      ),
                                      widthSpace5,
                                      CustomWidget().buildTextWidget(
                                          title: "Get Help",
                                          textColor: AppColors.green500,
                                          fontWeight: FontWeight.w500,
                                          // textAlign: TextAlign.center,
                                          fontSize: 16)
                                    ],
                                  ),
                                ),
                              ),
                              widthSpace5,
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 48,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: AppColors.green500),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        Images.starOutline,
                                        color: AppColors.whiteColor,
                                        width: 15,
                                        height: 15,
                                      ),
                                      widthSpace5,
                                      CustomWidget().buildTextWidget(
                                          title: "Rate Ride",
                                          textColor: AppColors.whiteColor,
                                          fontWeight: FontWeight.w500,
                                          // textAlign: TextAlign.center,
                                          fontSize: 16)
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )),
                    if (widget.status == "Cancelled")
                      Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            decoration: BoxDecoration(
                                border: Border.all(color: AppColors.green500),
                                borderRadius: BorderRadius.circular(8),
                                color: AppColors.whiteColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Images.helpIcon,
                                  color: AppColors.green500,
                                  width: 15,
                                  height: 15,
                                ),
                                widthSpace5,
                                CustomWidget().buildTextWidget(
                                    title: "Get Help",
                                    textColor: AppColors.green500,
                                    fontWeight: FontWeight.w500,
                                    // textAlign: TextAlign.center,
                                    fontSize: 16)
                              ],
                            ),
                          )),
                    if (widget.status == "Pre-Booked")
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CustomWidget().buildMaterialBtn(
                                radius: 8,
                                text: "Cancel Ride",
                                onPressed: () {
                                  Get.to(BookingCancelRideScreen());
                                },
                                color: AppColors.redColor400)),
                      )
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
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "\$200",
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
                  title: "Total Paid",
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
        heightSpace20,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            decoration: BoxDecoration(
                color: AppColors.green50,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Row(
              children: [
                Image.asset(
                  Images.referImage,
                  width: 99,
                  height: 73,
                ),
                widthSpace10,
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomWidget().buildTextWidget(
                        title: "Rate & Earn",
                        textColor: AppColors.green500,
                        fontWeight: FontWeight.w600,
                        textAlign: TextAlign.center,
                        fontSize: 16),
                    heightSpace5,
                    CustomWidget().buildTextWidget(
                        title: "Share your experience and earn a wallet bonus.",
                        textColor: AppColors.black400,
                        fontWeight: FontWeight.w400,
                        textAlign: TextAlign.start,
                        fontSize: 14),
                    heightSpace5,
                  ],
                ))
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _preBookedData() {
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Platform Fee",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "\$150",
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
                  title: "Total Paid",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
              CustomWidget().buildTextWidget(
                  title: "\$1150",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
            ],
          ),
        ),
        heightSpace15,
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: 
          CustomWidget().buildTextWidget(
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: "Platform Fee",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
              CustomWidget().buildTextWidget(
                  title: "\$100",
                  textColor: AppColors.black400,
                  fontWeight: FontWeight.w400,
                  textAlign: TextAlign.center,
                  fontSize: 14),
            ],
          ),
        ),
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
                  title: "Refund Amount",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
              CustomWidget().buildTextWidget(
                  title: "\$950",
                  textColor: AppColors.black500,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  fontSize: 16),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: CustomWidget().buildTextWidget(
              title:
                  "Refunds are processed within 3–5 business days. For more details, see our Terms & Conditions.",
              textColor: AppColors.black400,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
              fontSize: 14),
        ),
      ],
    );
  }
}
