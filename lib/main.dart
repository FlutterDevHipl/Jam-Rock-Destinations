
import 'dart:async';
import 'package:Jam_Rock_Destinations/Utils/app_images.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'Services/Internet_Controler.dart';
import 'Services/firebase_notification_service.dart';
import 'Utils/app_colors.dart';
import 'Utils/custom_widget.dart';
import 'WelcomeScreens/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseNotificationService.initializeFirebase();

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
    final InternetController internetController = Get.put(
      InternetController(),
      permanent: true,
    );
    return LocalizedApp(
      child: GetMaterialApp(
        title: 'Jam Rock Destination',
        debugShowCheckedModeBanner: false,
        localizationsDelegates: LocalizeAndTranslate.delegates,
        // builder: (context, child) => child!,
        builder: (context, child) {
          return Stack(
            children: [
              child!,

              /// INTERNET POPUP

              Obx(() {
                if (internetController.isConnected.value) {
                  return const SizedBox();
                }

                return
                //   Container(
                //   color: Colors.black54,
                //   child: Center(
                //     child: Material(
                //       borderRadius: BorderRadius.circular(16),
                //       child: Container(
                //         width: 300,
                //         padding: const EdgeInsets.all(20),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(16),
                //         ),
                //         child: Column(
                //           mainAxisSize: MainAxisSize.min,
                //           children: [
                //             const Icon(
                //               Icons.wifi_off,
                //               size: 50,
                //               color: Colors.red,
                //             ),
                //
                //             const SizedBox(height: 15),
                //
                //             const Text(
                //               "No Internet",
                //               style: TextStyle(
                //                 fontSize: 20,
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //
                //             const SizedBox(height: 10),
                //
                //             const Text(
                //               "Please check your internet connection",
                //               textAlign: TextAlign.center,
                //             ),
                //
                //             const SizedBox(height: 20),
                //
                //             Container(
                //               alignment: Alignment.center,
                //               child: Text("Retry",
                //                   style: TextStyle(
                //                       fontSize: 16,
                //                       fontWeight: FontWeight.bold,
                //                       color: Colors.white)),
                //               height: 50,
                //               width: 200,
                //               decoration: BoxDecoration(
                //                   color: Colors.blue,
                //                   borderRadius:
                //                   BorderRadius.all(Radius.circular(10))),
                //             )
                //           ],
                //         ),
                //       ),
                //     ),
                //   ),
                // );
                 Positioned.fill(
                  child: Material(
                    color: Colors.white,
                    child: SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  Images.noInternet,
                                  width: 350,
                                  height: 350,
                                ),


                                const SizedBox(height: 20),

                                CustomWidget().buildTextWidget(
                                  title: "No Internet Connection",
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  textColor: AppColors.black500,
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 10),

                                CustomWidget().buildTextWidget(
                                  title: "Check your connection and try again.",
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  textColor: AppColors.black400,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: CustomWidget().buildMaterialBtn(
                              radius: 8,
                              color: AppColors.green500,
                              text: "Retry",
                              onPressed: () async {
                                await internetController.checkInternet();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
          primarySwatch: Colors.blue,
          primaryColor: AppColors.blackColor,
          // pageTransitionsTheme: const PageTransitionsTheme(
          //   builders: {
          //     TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          //     TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          //   },
          // ),
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


// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_stripe/flutter_stripe.dart';
// import 'package:get/get.dart';
// import 'package:mmw_user_provider_app/Core/Utils/app_colors.dart';
//
// import 'Core/Services/firebase_notification_service.dart';
// import 'Core/Utils/shared_preferences.dart';
// import 'View/Common_Module/Auth/splash_screen.dart';
// import 'View/Common_Module/internet_controller.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   await SharedPreferencesUtil.init();
//
//   /// STRIPE KEY
//   Stripe.publishableKey = "pk_test_51OY3lNKZdTM0BzCkOd8aqGdu65oIeBBNGvS5LpN4JxfvsBuvsGnzwUFpzrytn8rNPzSuWgfj05dRRSdkRSvZgRAX00s9N2Pk1t";
//   // Stripe.publishableKey = "pk_live_51OY3lNKZdTM0BzCkh5XhZ9XYOTZvxAXMl3k74y27J9GHyLnds7vkxGGLJbxuD9sOjNMil24lh5ZaQYKV49fZdkHT009muioHHp";
//
//   await Stripe.instance.applySettings();
//
//   /// STATUS BAR
//   SystemChrome.setSystemUIOverlayStyle(
//     const SystemUiOverlayStyle(
//       statusBarColor: Colors.white,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Brightness.light,
//     ),
//   );
//   // Notification setup
//   try {
//     await Firebase.initializeApp(
//       options: const FirebaseOptions(
//         apiKey: 'AIzaSyBpmvEG5c7DjyplF15DthSGtYuH83kdrEU',
//         appId: '1:472804449848:android:106dd9e2ce29aea270d0cd',
//         messagingSenderId: '472804449848',
//         projectId: 'mmw-app-70e2e',
//         storageBucket: 'mmw-app-70e2e.firebasestorage.app',
//       ),
//     );
//   } catch (e) {
//     print("🔥 Firebase init error: $e");
//   }
//   // NotificationService.initialize();
//   /// Initialize notifications
//   await FirebaseNotificationService.initializeFirebase();
//
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final InternetController internetController = Get.put(
//       InternetController(),
//       permanent: true,
//     );
//
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'MMW',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColors.appThemeColor,
//         ),
//         useMaterial3: true,
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           systemOverlayStyle: SystemUiOverlayStyle.dark,
//         ),
//       ),
//       builder: (context, child) {
//         return Stack(
//           children: [
//             child!,
//
//             /// INTERNET POPUP
//
//             Obx(() {
//               if (internetController.isConnected.value) {
//                 return const SizedBox();
//               }
//
//               return Container(
//                 color: Colors.black54,
//                 child: Center(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(16),
//                     child: Container(
//                       width: 300,
//                       padding: const EdgeInsets.all(20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Icon(
//                             Icons.wifi_off,
//                             size: 50,
//                             color: Colors.red,
//                           ),
//
//                           const SizedBox(height: 15),
//
//                           const Text(
//                             "No Internet",
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//
//                           const SizedBox(height: 10),
//
//                           const Text(
//                             "Please check your internet connection",
//                             textAlign: TextAlign.center,
//                           ),
//
//                           const SizedBox(height: 20),
//
//                           Container(
//                             alignment: Alignment.center,
//                             child: Text("Retry",
//                                 style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.white)),
//                             height: 50,
//                             width: 200,
//                             decoration: BoxDecoration(
//                                 color: Colors.blue,
//                                 borderRadius:
//                                 BorderRadius.all(Radius.circular(10))),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }),
//           ],
//         );
//       },
//       home: SplashScreen(),
//     );
//   }
// }

