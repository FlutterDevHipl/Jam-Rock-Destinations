import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  final List<Map<String, String>> rideList = [
    {
      "title": "Affordable & Quick",
      "subtitle": "Taxi",
      "image": "assets/images/taxi.png",
    },
    {
      "title": "Pre Book &",
      "subtitle": "Ride Stress-Free",
      "image": "assets/images/prebook.png",
    },
    {
      "title": "Enjoy Ride with",
      "subtitle": "Car Comfort",
      "image": "assets/images/car.png",
    },
    {
      "title": "See All",
      "subtitle": "Services",
      "image": "assets/images/services.png",
    },
  ];
}
