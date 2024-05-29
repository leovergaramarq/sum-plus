import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sum_plus/data/datasources/local/hive_value_manager.dart';

import 'package:sum_plus/domain/models/user.dart';

class UserLocalDatasource {
  UserLocalDatasource() {
    _hiveUserManager = HiveValueManager(_userKey, _domain);
  }

  final String _domain = 'flutter.domain.user';
  final String _userKey = 'user';
  bool _boxOpened = false;
  late HiveValueManager _hiveUserManager;

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
    if (!_boxOpened) await _openBox();

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
    if (!_boxOpened) await _openBox();

    final String? userString = _hiveUserManager.getValue();
    if (userString == null) return null;
    final Map<String, dynamic> userMap = jsonDecode(userString);
    return User.fromJson(userMap);
  }

  Future<User> _setUser(User user) async {
    if (!_boxOpened) await _openBox();

    final String userString = jsonEncode(user.toJson());
    final bool result = await _hiveUserManager.putValue(userString);
    if (!result) {
      return Future.error('User couldn\'t be saved');
    }
    return user;
  }

  Future<bool> removeUser() async {
    if (!_boxOpened) await _openBox();

    return await _hiveUserManager.removeValue();
  }

  Future<bool> containsUser() async {
    if (!_boxOpened) await _openBox();

    return _hiveUserManager.getValue() != null;
  }

  Future<void> _openBox() async {
    await Hive.openBox(_domain);
    _boxOpened = true;
  }
}
