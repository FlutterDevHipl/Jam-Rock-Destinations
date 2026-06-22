import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/network_utils.dart';

class NotificationController extends GetxController {
  var isLoading = false.obs;
  final internetStatus = false.obs;
  final List<Map<String, String>> notificationList = [
    {
      "title": "Booking Confirmed!",
      "message":
          "Your ride with Marcus Brown is confirmed for 28 May, 2025 at 10:00 AM. Sit back and relax – we've got you covered!",
      "time": "4h",
    },
    {
      "title": "Ride Completed",
      "message":
          "Your ride with Marcus Brown is complete. We hope you had a great experience! Don't forget to leave a review.",
      "time": "4h",
    },
    {
      "title": "Payment Successful",
      "message":
          "\$12.50 has been deducted for your ride to Dunn's River Falls, Ocho Rios.",
      "time": "4h",
    },
    {
      "title": "Ride Cancelled",
      "message":
          "Your ride with Marcus Brown has been cancelled. Refund will be processed as per cancellation policy.",
      "time": "Yesterday",
    },
  ];

  void checkNetworkAndFetch() async {
    isLoading.value = true;
    internetStatus.value = await NetworkUtils.isConnected();
    if (internetStatus.value) {
      getNotificationApi("");
    } else {
      isLoading.value = false;
    }
  }

  getNotificationApi(String value) async {
    try {
    
    } catch (e) {
     
      isLoading.value = false;
      log("search error ${e.toString()}");
    }
  }

}
