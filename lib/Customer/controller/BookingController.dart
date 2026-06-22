import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingController extends GetxController {
  var isLoading = false.obs;

  final List<Map<String, dynamic>> bookings = [
    {
      "rideName": "Taxi Ride",
      "from": "Kingston",
      "to": "Montage Bay",
      "date": "10:11 AM, 23 May 2026",
      "amount": "\$800",
      "status": "Completed",
      "statusColor": AppColors.green500,
      "amountColor": AppColors.black400,
      "icon": Icons.check_circle_outline,
    },
    {
      "rideName": "Car Ride",
      "from": "Kingston",
      "to": "Montage Bay",
      "date": "10:11 AM, 23 May 2026",
      "amount": "\$12",
      "status": "Cancelled",
      "statusColor": AppColors.redColor400,
      "amountColor": AppColors.redColor400,
      "icon": Icons.cancel_outlined,
    },
    {
      "rideName": "Taxi Ride",
      "from": "Kingston",
      "to": "Montage Bay",
      "date": "10:11 AM, 23 May 2026",
      "amount": "\$232",
      "status": "Pre-Booked",
      "statusColor": AppColors.amberColor,
      "amountColor": AppColors.black400,
      "icon": Icons.access_time,
    },
    {
      "rideName": "Bike Ride",
      "from": "Kingston",
      "to": "Montage Bay",
      "date": "10:11 AM, 23 May 2026",
      "amount": "\$800",
      "status": "Completed",
      "statusColor": AppColors.green500,
      "amountColor": AppColors.black400,
      "icon": Icons.check_circle_outline,
    },
  ];

  String selectedReason = "Other";

  final List<String> reasons = [
    "User is too far",
    "Change of plans",
    "Wrong location entered",
    "Accepted by mistake",
    "Other",
  ];
}
