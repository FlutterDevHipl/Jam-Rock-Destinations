
import 'dart:async';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:solfana/Utils/app_colors.dart';
import 'package:solfana/WelcomeScreens/splashScreen.dart';
import 'Services/firebase_notification_service.dart';

Future<void> main() async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  await FirebaseNotificationService.initializeFirebase();



  // ==================== ANALYTICS & CRASHLYTICS ====================
  final analytics = FirebaseAnalytics.instance;
  final crashlytics = FirebaseCrashlytics.instance;

  await analytics.setAnalyticsCollectionEnabled(true);

  // Enable Debug Mode for DebugView
  if (kDebugMode) {
    await analytics.setDefaultEventParameters({'debug_mode': '1'});
    await analytics.setUserProperty(name: 'debug_mode', value: 'true');
  }

  // Enable Crashlytics (disable in debug if you want)
  await crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

  // Pass Flutter errors to Crashlytics
  FlutterError.onError = crashlytics.recordFlutterFatalError;

// ==================== INITIALIZATIONS ====================
  // ✅ Step 1 — Run truly required inits in parallel (before runApp)
  runZonedGuarded(() async {
    await Future.wait([
      Hive.initFlutter().then((_) => Future.wait([
        Hive.openBox('userBox'),
        Hive.openBox('downloadBox'),
      ])),
      _initLocalization(), // LocalizedApp needs this before runApp
    ]);

    // ✅ Step 2 — Show UI immediately
    runApp(MyApp());

    // ✅ Step 3 — Heavy inits AFTER UI is visible (non-blocking)
    _initInBackground();

  }, (error, stack) {
    crashlytics.recordError(error, stack, fatal: true);
  });
}


// ==================== BACKGROUND INITIALIZATION ====================
Future<void> _initInBackground() async  {
  await Future.wait([
    MobileAds.instance.initialize(), // Only once here ✅
    JustAudioBackground.init(
      androidNotificationChannelId: 'com.solfana',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,

    ),
  ]);


}

Future<void> _initLocalization() async {
  try {

    await LocalizeAndTranslate.init(
      assetLoader: const AssetLoaderRootBundleJson('assets/Languages/'),
      supportedLanguageCodes: ['fr', 'en'],
    );
  } catch (e) {
    debugPrint('Localization failed: $e');
  }
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
