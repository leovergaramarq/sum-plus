import 'package:shared_preferences/shared_preferences.dart';

class AuthLocalDatasource {
  final String tokenKey = 'authToken';
  SharedPreferences? prefs;

  Future<bool> saveToken(String token) async {
    prefs ??= await SharedPreferences.getInstance();
    return await prefs!.setString(tokenKey, token);
  }

  Future<bool> removeToken() async {
    prefs ??= await SharedPreferences.getInstance();
    return await prefs!.remove(tokenKey);
  }

  Future<bool> containsToken() async {
    prefs ??= await SharedPreferences.getInstance();
    return prefs!.containsKey(tokenKey);
  }
}
