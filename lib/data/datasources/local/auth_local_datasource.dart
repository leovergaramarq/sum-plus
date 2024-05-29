import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  // AuthLocalDatasource() {
  //   SharedPreferences.getInstance().then((value) => prefs = value);
  // }

  final String tokenKey = 'authToken';
  SharedPreferences? prefs;

  Future<bool> saveToken(String token) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return await prefs!.setString(tokenKey, token);
  }

  // Future<String?> getToken() async {
  //   if (prefs == null) {
  //     prefs = await SharedPreferences.getInstance();
  //   }
  //   return prefs!.getString(tokenKey);
  // }

  Future<bool> removeToken() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return await prefs!.remove(tokenKey);
  }

  Future<bool> containsToken() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs!.containsKey(tokenKey);
  }
}
