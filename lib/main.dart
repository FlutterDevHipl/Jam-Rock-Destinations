
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'Services/firebase_notification_service.dart';
import 'Utils/app_colors.dart';
import 'WelcomeScreens/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // await FirebaseNotificationService.initializeFirebase();

  await Hive.initFlutter();

  await Future.wait([
    Hive.openBox('userBox'),
    Hive.openBox('downloadBox'),
  ]);

  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return LocalizedApp(
      child: GetMaterialApp(
        title: 'Solfana',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: LocalizeAndTranslate.delegates,
        builder: (context, child) => child!,
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: AppColors.blackColor,
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            },
          ),
          appBarTheme: const AppBarTheme(
            shadowColor: AppColors.blackColor,
            backgroundColor: AppColors.blackColor,
            elevation: 0,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          primarySwatch: Colors.blue,
          primaryColor: AppColors.blackColor,
          scaffoldBackgroundColor: AppColors.blackColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.blackColor,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(color: Colors.white),
          ),
        ),
        home: const Splashscreen(),
      ),
    );
  }
}
