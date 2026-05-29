import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';


class NetworkUtils {
  static Future<bool> isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      return false; 
    }
    
    try {
      final result = await InternetAddress.lookup('example.com')
          .timeout(const Duration(seconds: 10));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true; // real internet available
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false; // no internet
    } on TimeoutException catch (_) {
      return false; // no internet
    }
  }
}
