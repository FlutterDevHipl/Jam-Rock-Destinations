import 'package:Jam_Rock_Destinations/Utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EarningController extends GetxController {
  var isLoading = false.obs;
  var isDailyTabClick = true.obs;
  var isWeeklyTabClick = false.obs;
  var isMonthlyTabClick = false.obs;

  final earningsData = [2000, 1500, 900, 1450, 1500, 1050];
}
