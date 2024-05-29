import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  static bool lastNetworkCheck = false;

  static Future<bool> hasNetwork() async {
    try {
      // throw new Exception("Test Exception");
      final ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      // print(connectivityResult.toString());
      lastNetworkCheck = connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile;
    } catch (e) {
      print(e);
      lastNetworkCheck = false;
    }
    return lastNetworkCheck;
  }
}
