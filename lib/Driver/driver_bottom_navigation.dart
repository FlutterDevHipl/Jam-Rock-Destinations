import 'dart:io';

import 'package:Jam_Rock_Destinations/Customer/home_screen.dart';
import 'package:Jam_Rock_Destinations/Driver/home/DriverHomeScreen.dart';
import 'package:Jam_Rock_Destinations/Driver/ride_history/RideHistoryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Common/setting/setting.dart';
import '../Utils/app_colors.dart';
import '../Utils/app_images.dart';
import 'earning/EarningScreen.dart';


class DriverBottomNavigation extends StatefulWidget {
  final int index;
  final int eventsFromIndex; // 👈 ADD THIS

  const DriverBottomNavigation({
    super.key,
    this.index = 0,
    this.eventsFromIndex = 0,
  });

  @override
  State<DriverBottomNavigation> createState() => _DriverBottomNavigationState();
}

class _DriverBottomNavigationState extends State<DriverBottomNavigation> {
  int currentIndex = 0;
  int eventsFromIndex = 0; // 👈 IMPORTANT

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
    eventsFromIndex = widget.eventsFromIndex;



    // FirebaseMessaging.instance.getInitialMessage().then((message) {
    //   print('RemoteMessage: $message');
    //   if (message != null) {
    //     WidgetsBinding.instance.addPostFrameCallback((_) {
    //       Get.to(() => const NotificationsView());
    //     });
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: buildScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whiteColor,
        currentIndex: currentIndex,
        selectedItemColor: AppColors.green500,
        unselectedItemColor: AppColors.black200,
        type: BottomNavigationBarType.fixed,

        onTap: (index) {
          setState(() {
             if (index == 1) {
              eventsFromIndex = 0;
            }
            currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
               Images.homeIcon,
              color: AppColors.black200,
            ),
            activeIcon: SvgPicture.asset(
              Images.homeIcon,
              color: AppColors.green500,
            ),
            label: "Home",

          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
             Images.earningIcon,
              color: AppColors.black200,
            ),
            activeIcon:  SvgPicture.asset(
                Images.earningIcon,color: AppColors.green500,
            ),
            label: "Earnings",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
               Images.riderHistory,
              color: AppColors.black200,
            ),
            activeIcon: SvgPicture.asset(
                Images.riderHistory,
              color: AppColors.green500,
            ),
            label: "Ride History",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
             Images.settingIcon,
              color: AppColors.black200,
            ),
            activeIcon: SvgPicture.asset(
              Images.settingIcon,
              color: AppColors.green500,
            ),
            label: "Settings",
          ),
        ],
      ),
    );
  }

  Widget buildScreen() {
    switch (currentIndex) {
      case 1:
        return EarningScreen();
      case 2:
        return const RideHistoryScreen();
      case 3:
        return const SettingsScreen();
      default:
        return const DriverHomeScreen();
    }
  }
}
