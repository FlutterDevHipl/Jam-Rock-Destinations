import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';




class FirebaseNotificationService {

  /// =========================================
  /// FLAGS
  /// =========================================

  static bool _listenersInitialized = false;
  static bool _navigationInProgress = false;

  /// =========================================
  /// LOCAL NOTIFICATION
  /// =========================================

  static final FlutterLocalNotificationsPlugin
  flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  /// =========================================
  /// ANDROID CHANNEL
  /// =========================================

  static const AndroidNotificationChannel
  androidSettings =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description:
    'This channel is used for important notifications.',
    importance: Importance.high,
    playSound: true,
  );

  /// =========================================
  /// BACKGROUND HANDLER
  /// =========================================

  static Future<void>
  firebaseMessagingBackgroundHandler(RemoteMessage message,) async {
    await Firebase.initializeApp();

    log(
      "📥 Background Message: ${message.data}",
    );
  }

  /// =========================================
  /// INITIALIZE FIREBASE
  /// =========================================

  static Future<void> initializeFirebase() async {
    log("🔥 Initializing Firebase");

    try {
      // await Firebase.initializeApp(
      //   options: FirebaseOptions(
      //     apiKey: Platform.isIOS
      //         ? 'AIzaSyBsDxjTvwTCND9JILyTOKv5FSUvmS57BLE'
      //         : 'AIzaSyAA7l_HWcO360-lDx-sJbBfVb7BuUv68eM',
      //     appId: Platform.isIOS
      //         ? '1:794457403902:ios:04ad2c0e9a7eedaf4490af'
      //         : '1:794457403902:android:23efc12954dad77d4490af',
      //     messagingSenderId: '794457403902',
      //     projectId: 'Jam Rock Destinations-app',
      //     storageBucket: 'Jam Rock Destinations-app.firebasestorage.app',
      //   ),
      // );
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: Platform.isIOS
              ? 'AIzaSyBsDxjTvwTCND9JILyTOKv5FSUvmS57BLE'
              : 'AIzaSyANCA4c91LyrCKcH66myupH2RmGQhOK2tI',
          appId: Platform.isIOS
              ? '1:794457403902:ios:04ad2c0e9a7eedaf4490af'
              : '1:870545618442:android:4f158afa41a0682d6ad1f3',
          messagingSenderId: '870545618442',
          projectId: 'jam-rock',
          storageBucket: 'jam-rock.firebasestorage.app',
        ),
      );
    } catch (e) {
      log("Firebase init error: $e");
    }

    /// =========================================
    /// REQUEST PERMISSION
    /// =========================================

    await FirebaseMessaging.instance
        .requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    /// =========================================
    /// BACKGROUND HANDLER
    /// =========================================

    FirebaseMessaging.onBackgroundMessage(
      firebaseMessagingBackgroundHandler,
    );

    /// =========================================
    /// LOCAL NOTIFICATION INIT
    /// =========================================

    const InitializationSettings
    initializationSettings =
    InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),

      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin
        .initialize(

      initializationSettings,

      onDidReceiveNotificationResponse:
          (NotificationResponse response,) async {
        try {
          if (response.payload != null &&
              response.payload!.isNotEmpty) {
            final decodedPayload =
            json.decode(
              response.payload!,
            );

            if (decodedPayload
            is Map<String, dynamic>) {
              // handleNavigation(
              //   decodedPayload,
              // );
            }
          }
        } catch (e) {
          log(
            "❌ Notification tap error: $e",
          );
        }
      },
    );

    /// =========================================
    /// ANDROID CHANNEL
    /// =========================================

    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(
        androidSettings,
      );
    }

    /// =========================================
    /// FOREGROUND DISPLAY IOS
    /// =========================================

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    /// =========================================
    /// FOREGROUND MESSAGE
    /// =========================================

    FirebaseMessaging.onMessage.listen(
      _onMessageHandler,
    );

    /// =========================================
    /// INIT LISTENERS ONLY ONCE
    /// =========================================

    if (!_listenersInitialized) {
      _listenersInitialized = true;

      setupInteractedMessage();
    }

    log("✅ Firebase Initialized");
  }

  /// =========================================
  /// FOREGROUND MESSAGE
  /// =========================================

  static void _onMessageHandler(RemoteMessage message,) {
    log(
      "📥 Foreground Message: ${message.data}",
    );

    if (Platform.isIOS &&
        message.notification != null) {
      return;
    }

    final title =
        message.notification?.title ??
            message.data['title'];

    final body =
        message.notification?.body ??
            message.data['body'];

    if (title == null &&
        body == null) {
      return;
    }

    flutterLocalNotificationsPlugin.show(
      message.hashCode,

      title,

      body,

      NotificationDetails(

        android:
        AndroidNotificationDetails(

          androidSettings.id,

          androidSettings.name,

          importance: Importance.high,

          priority: Priority.high,

          playSound: true,

          icon: '@mipmap/ic_launcher',
        ),

        iOS:
        const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),

      payload: json.encode(
        message.data,
      ),
    );
  }

  /// =========================================
  /// HANDLE TERMINATED / BACKGROUND
  /// =========================================

  static Future<void>
  setupInteractedMessage() async {

    /// TERMINATED STATE

    final initialMessage =
    await FirebaseMessaging.instance
        .getInitialMessage();

    if (initialMessage != null) {
      log(
        "🚀 App opened from terminated state",
      );

      Future.delayed(
        const Duration(milliseconds: 500),
            () {
          // handleNavigation(
          //   initialMessage.data,
          // );
        },
      );
    }

    /// BACKGROUND -> FOREGROUND

    FirebaseMessaging.onMessageOpenedApp
        .listen(

          (RemoteMessage message,) {
        log(
          "📲 App opened from background",
        );

        Future.delayed(
          const Duration(milliseconds: 500),
              () {
            // handleNavigation(
            //   message.data,
            // );
          },
        );
      },
    );
  }

/// =========================================
/// NAVIGATION HANDLER
/// =========================================


// static Future<void> handleNavigation(
//     Map<String, dynamic> data,
//     ) async {
//
//   if (_navigationInProgress) return;
//
//   _navigationInProgress = true;
//
//   try {
//
//     print("📌 Navigation Payload: $data");
//
//     if (data.isEmpty) return;
//
//     final type = data["clickValue"]?.toString();
//
//     /// 🔥 IMPORTANT
//     /// Give app enough time to build navigator/context
//     await Future.delayed(
//       const Duration(seconds: 5),
//     );
//
//     if (Get.key.currentState == null) {
//       print("❌ Navigator not ready");
//       return;
//     }
//
//     switch (type) {
//
//       case "HOME":
//
//         Get.offAll(
//               () => DashboardScreen(
//             currentIndex: 0,
//           ),
//         );
//
//         break;
//
//       case "PLAYER":
//
//         // Get.to(
//         //       () => PlayerView(),
//         //   preventDuplicates: true,
//         // );
//         Get.to(
//               () => AudiobookView(),
//           preventDuplicates: true,
//         );
//
//         break;
//
//       case "ALBUM":
//
//         Get.to(
//               () => AudiobookView(),
//           preventDuplicates: true,
//         );
//
//         break;
//
//       case "CATEGORY":
//
//         Get.to(
//               () => AudiobookView(),
//           preventDuplicates: true,
//         );
//
//         break;
//
//       case "SEARCH":
//
//         Get.offAll(
//               () => DashboardScreen(
//             currentIndex: 1,
//           ),
//         );
//
//         break;
//
//       default:
//
//         Get.offAll(
//               () => DashboardScreen(
//             currentIndex: 0,
//           ),
//         );
//     }
//
//   } catch (e, stack) {
//
//     print("❌ Navigation Error: $e");
//     print(stack);
//
//   } finally {
//
//     await Future.delayed(
//       const Duration(seconds: 1),
//     );
//
//     _navigationInProgress = false;
//   }
// }

}