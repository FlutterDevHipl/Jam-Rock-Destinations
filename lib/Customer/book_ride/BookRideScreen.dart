

import 'package:Jam_Rock_Destinations/Customer/controller/BookRideController.dart';
import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:Jam_Rock_Destinations/Utils/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../Common/controller/LocationController.dart';

class BookRideScreen extends StatefulWidget {
  const BookRideScreen({super.key});

  @override
  State<BookRideScreen> createState() => _BookRideScreenState();
}

class _BookRideScreenState extends State<BookRideScreen> {
  BookRidecontroller controller = Get.put(BookRidecontroller());
  Locationcontroller locationController = Get.put(Locationcontroller());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _showPickupBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return AddressPointWidget();
      },
    ).then((_) {
      controller.sheetOpened.value = false;
    });
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
                title: "Book Ride",
                textColor: AppColors.black500,
                fontWeight: FontWeight.w700,
                fontSize: 20)),
        body: SafeArea(
          child: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.green500))
                : Stack(
                    children: [
                      SizedBox( 
                        width: Get.width,
                        height: Get.height,
                        child: GoogleMap(
                          markers: locationController.markers,
                          initialCameraPosition: const CameraPosition(
                            target: Locationcontroller.initialPosition,
                            zoom: 14,
                          ),
                          onMapCreated: (controller) async {
                            locationController.mapController = controller;

                            await locationController.fetchLocation();
                            await locationController.moveToCurrentLocation();
                          },
                          myLocationEnabled: true,
                          myLocationButtonEnabled: false,
                          zoomControlsEnabled: false,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: AppColors.whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(.08),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(color: AppColors.green500)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _locationTile(
                                color: Colors.green,
                                loctionCont: controller.pickupLocCont,
                                hintText: "Pickup Location",
                                isPickUpValue: true,
                                isDropValue: false),
                            Padding(
                              padding: const EdgeInsets.only(left: 6),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Images.dottedLine,
                                    // height: 35,
                                  ),
                                  widthSpace25,
                                  Expanded(
                                    child: Divider(
                                      color: AppColors.black50,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            _locationTile(
                                color: Colors.amber,
                                loctionCont: controller.dropLocCont,
                                hintText: "Drop Location",
                                isPickUpValue: false,
                                isDropValue: true),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ));
  }

  Widget _locationTile({
    required Color color,
    required String hintText,
    required TextEditingController loctionCont,
    required bool isPickUpValue,
    isDropValue,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 2,
            ),
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
        Expanded(
            child: TextFormField(
          cursorColor: AppColors.green500,
          controller: loctionCont,
          keyboardType: TextInputType.text,
          style: GoogleFonts.inter(
            color: AppColors.black500,
            fontSize: 14,
          ),
          onEditingComplete: () {
            // _checkLocations();
            controller.isPickUp.value = isPickUpValue;
            controller.isDrop.value = isDropValue;
            controller.isPickUp.value
                ? controller.buttonText.value = "Confirm Pickup"
                : controller.buttonText.value = "Confirm Drop";
            _showPickupBottomSheet();
          },
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            isDense: true,
            contentPadding:
                const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
            errorStyle: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            errorMaxLines: 2,
            hintText: hintText,
            hintStyle: GoogleFonts.inter(
              fontSize: 14,
              color: AppColors.black200,
              fontWeight: FontWeight.w500,
            ),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
        )),
      ],
    );
  }
}

class AddressPointWidget extends StatelessWidget {
  AddressPointWidget({
    super.key,
  });

  BookRidecontroller controller = Get.put(BookRidecontroller());

  void _showPassengerBottomSheet() {
    Get.bottomSheet(
      PassengerBottomSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // heightSpace10,
          Container(
            width: 65,
            height: 4,
            decoration: BoxDecoration(
                color: AppColors.black50,
                borderRadius: BorderRadius.circular(12)),
          ),
          heightSpace30,
          CustomWidget().buildTextWidget(
              title: controller.isPickUp.value
                  ? "Set your Pickup Point"
                  : "Set your Drop Point",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500,
              textAlign: TextAlign.center),
          heightSpace5,
          CustomWidget().buildTextWidget(
              title: "Drag map to move pin",
              fontSize: 16,
              fontWeight: FontWeight.w400,
              textColor: AppColors.black400,
              textAlign: TextAlign.center),
          heightSpace30,
          Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColors.offWhite,
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  widthSpace10,
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: controller.isPickUp.value
                            ? AppColors.green500
                            : AppColors.amberColor,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: CircleAvatar(
                        radius: 4,
                        backgroundColor: controller.isPickUp.value
                            ? AppColors.green500
                            : AppColors.amberColor,
                      ),
                    ),
                  ),
                  widthSpace10,
                  CustomWidget().buildTextWidget(
                      title: controller.isPickUp.value
                          ? controller.pickupLocCont.text
                          : controller.dropLocCont.text,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      textColor: AppColors.black500,
                      textAlign: TextAlign.center),
                ],
              )),
          heightSpace12,
          GestureDetector(
            onTap: () {
              if (controller.buttonText.value == "Confirm Drop") {
                Future.delayed(
                  const Duration(milliseconds: 300),
                  () => _showPassengerBottomSheet(),
                );
              }
              Get.back();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              width: Get.width,
              decoration: BoxDecoration(
                  color: AppColors.green500,
                  borderRadius: BorderRadius.circular(8)),
              child: CustomWidget().buildTextWidget(
                  title: controller.buttonText.value,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.whiteColor,
                  textAlign: TextAlign.center),
            ),
          ),
          heightSpace20,
        ],
      ),
    );
  }
}

class PassengerBottomSheet extends StatelessWidget {
  PassengerBottomSheet({super.key});

  BookRidecontroller controller = Get.put(BookRidecontroller());

  @override
  Widget build(BuildContext context) {
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
          Center(
            child: Container(
              width: 65,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.black50,
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
          heightSpace20,
          CustomWidget().buildTextWidget(
              title: "Select Passengers",
              fontSize: 18,
              fontWeight: FontWeight.w700,
              textColor: AppColors.black500,
              textAlign: TextAlign.center),
          heightSpace10,
          Obx(
            () => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(controller.items.length, (index) {
                  final isSelected = index == controller.selectedIndex.value;

                  // LAST ITEM = DROPDOWN
                  if (index == controller.items.length - 1) {
                    return GestureDetector(
                      onTapDown: (details) {
                        // _openMoreMenu(context, details.globalPosition);
                        controller.openPessengersMoreMenu(
                            context, details.globalPosition);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.green500
                                : AppColors.offWhite,
                            width: 1.2,
                          ),
                          color: isSelected
                              ? AppColors.green50
                              : AppColors.offWhite,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: isSelected
                                  ? AppColors.green500
                                  : AppColors.black300,
                            ),
                            const SizedBox(width: 4),
                            CustomWidget().buildTextWidget(
                                title: controller.selectedValue.value == "9"
                                    ? "9"
                                    : controller.selectedValue.value,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                textColor: isSelected
                                    ? AppColors.green500
                                    : AppColors.black300,
                                textAlign: TextAlign.center),
                            const Icon(Icons.arrow_drop_down_sharp, size: 18),
                          ],
                        ),
                      ),
                    );
                  }

                  return GestureDetector(
                    onTap: () => controller.onPessengersSelect(
                        index, controller.items[index]),
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.green500
                              : AppColors.offWhite,
                          width: 1.2,
                        ),
                        color:
                            isSelected ? AppColors.green50 : AppColors.offWhite,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.person,
                            size: 16,
                            color: isSelected
                                ? AppColors.green500
                                : AppColors.black300,
                          ),
                          const SizedBox(width: 4),
                          CustomWidget().buildTextWidget(
                              title: controller.items[index],
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              textColor: isSelected
                                  ? AppColors.green500
                                  : AppColors.black300,
                              textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          heightSpace25,
          Obx(() => int.tryParse(controller.selectedValue.value.toString())! >=
                  9
              ? CustomWidget().buildTextWidget(
                  title:
                      "Great news! We’re arranging a customized vehicle option specially for your group of 15+ passengers.",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black500,
                  textAlign: TextAlign.start)
              : CustomWidget().buildTextWidget(
                  title: "Select Your Ride",
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  textColor: AppColors.black500,
                  textAlign: TextAlign.center)),
          heightSpace15,
          // _rideTile(
          //     name: "Taxi Ride",
          //     price: "\$1150",
          //     seats: "3-4",
          //     dropTime: "Drop by 4:10 PM",
          //     reachedTime: "5 mins away"),
          // _rideTile(
          //     name: "Car Ride",
          //     price: "\$1150",
          //     seats: "4",
          //     dropTime: "Drop by 4:10 PM",
          //     reachedTime: "5 mins away"),
          // _rideTile(
          //     name: "Car Ride",
          //     price: "\$1150",
          //     seats: "4",
          //     dropTime: "Drop by 4:10 PM",
          //     reachedTime: "5 mins away"),
          Obx(
            () => int.tryParse(controller.selectedValue.value.toString())! >= 9
                ? CustomWidget().buildTextWidget(
                    title:
                        "Simply request a callback, and our team will connect with you shortly to help you with the best and most comfortable travel arrangement for your trip!",
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    textColor: AppColors.black400,
                    textAlign: TextAlign.start)
                : SizedBox(
                    height: 200,
                    child: ListView.builder(
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return _rideTile(
                            name: "Car Ride",
                            price: "\$1150",
                            seats: "4",
                            dropTime: "Drop by 4:10 PM",
                            reachedTime: "5 mins away");
                      },
                    ),
                  ),
          ),
          const SizedBox(height: 20),
          Obx(
            () => GestureDetector(
              onTap: () {
                if (int.tryParse(controller.selectedValue.value.toString())! >=
                    9) {
                  CustomWidget().showSuccessPopup(
                      title: "Request Sent!",
                      message: "Our admin team will contact you shortly",
                      onPressed: () {},
                      buttonText: "Okay");
                } else {}
                Get.back();
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                width: Get.width,
                decoration: BoxDecoration(
                    color: AppColors.green500,
                    borderRadius: BorderRadius.circular(8)),
                child: CustomWidget().buildTextWidget(
                    title: int.tryParse(
                                controller.selectedValue.value.toString())! >=
                            9
                        ? "Request a Call Back"
                        : "Confirm Ride",
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    textColor: AppColors.whiteColor,
                    textAlign: TextAlign.center),
              ),
            ),
          ),
          heightSpace20,
        ],
      ),
    );
  }

  Widget _rideTile({
    required String name,
    required String price,
    required String seats,
    required String dropTime,
    required String reachedTime,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.black50))),
      child: Row(
        children: [
          Image.asset(
            Images.taxi,
            width: 100,
            height: 55,
          ),
          widthSpace10,
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: name,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.black500,
                  textAlign: TextAlign.center),
              CustomWidget().buildTextWidget(
                  title: reachedTime,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.black400,
                  textAlign: TextAlign.center),
              CustomWidget().buildTextWidget(
                  title: dropTime,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  textColor: AppColors.yellow700,
                  textAlign: TextAlign.center),
            ],
          )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomWidget().buildTextWidget(
                  title: price,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  textColor: AppColors.green500,
                  textAlign: TextAlign.center),
              Row(
                children: [
                  Icon(
                    Icons.person,
                    size: 16,
                    color: AppColors.black300,
                  ),
                  widthSpace5,
                  CustomWidget().buildTextWidget(
                      title: seats,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      textColor: AppColors.black400,
                      textAlign: TextAlign.center),
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
