import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class InternetController extends GetxController {

  StreamSubscription<List<ConnectivityResult>>?
  connectivitySubscription;

  /// INTERNET STATUS
  RxBool isConnected = true.obs;

  @override
  void onInit() {

    super.onInit();

    checkInternet();

    listenInternetConnection();
  }

  /// CHECK INTERNET
  Future<void> checkInternet() async {

    List<ConnectivityResult> result =
    await Connectivity().checkConnectivity();

    updateConnectionStatus(result);
  }

  /// LISTENER
  void listenInternetConnection() {

    connectivitySubscription =
        Connectivity()
            .onConnectivityChanged
            .listen((List<ConnectivityResult> result) {

          updateConnectionStatus(result);
        });
  }

  /// UPDATE STATUS
  void updateConnectionStatus(
      List<ConnectivityResult> result,
      ) {

    bool internetAvailable =
        result.contains(ConnectivityResult.mobile) ||
            result.contains(ConnectivityResult.wifi) ||
            result.contains(ConnectivityResult.ethernet);

    isConnected.value = internetAvailable;
  }

  @override
  void onClose() {

    connectivitySubscription?.cancel();

    super.onClose();
  }
}
