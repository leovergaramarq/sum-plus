import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sum_plus/domain/models/user.dart';

class UserLocalDatasource {
  UserLocalDatasource() {
    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  final String userKey = 'user';
  SharedPreferences? prefs;

  Future<User?> getUser() async => await _getUser();

  Future<User> setUser(User user) async => await _setUser(user);

  Future<User> updateUser(User user) async => await _setUser(user);

  Future<User> updatePartialUser(int id,
      {String? firstName,
      String? lastName,
      String? email,
      String? birthDate,
      String? degree,
      String? school,
      int? level}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    final User? user = await _getUser();
    if (user == null) {
      return Future.error('User doesn\'t exist');
    }

    if (firstName != null) user.firstName = firstName;
    if (lastName != null) user.lastName = lastName;
    if (email != null) user.email = email;
    if (birthDate != null) user.birthDate = birthDate;
    if (degree != null) user.degree = degree;
    if (school != null) user.school = school;
    if (level != null) user.level = level;

    return await _setUser(user);
  }

  Future<User?> _getUser() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    final String? userString = prefs!.getString(userKey);
    if (userString == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userString);
    return User.fromJson(userMap);
  }

  Future<User> _setUser(User user) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    final String userString = jsonEncode(user.toJson());
    final bool result = await prefs!.setString(userKey, userString);
    if (!result) {
      return Future.error('User couldn\'t be saved');
    }
    return user;
  }

  Future<bool> removeUser() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return await prefs!.remove(userKey);
  }

  Future<bool> containsUser() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs!.containsKey(userKey);
  }
}
