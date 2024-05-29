import 'package:loggy/loggy.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkUtil {
  static bool lastNetworkCheck = false;

  static Future<bool> hasNetwork() async {
    try {
      final ConnectivityResult connectivityResult =
          await (Connectivity().checkConnectivity());
      lastNetworkCheck = connectivityResult == ConnectivityResult.wifi ||
          connectivityResult == ConnectivityResult.mobile;
    } catch (err) {
      logError(err);
      lastNetworkCheck = false;
    }
    return lastNetworkCheck;
  }
}
