import 'package:loggy/loggy.dart';

import 'package:sum_plus/data/datasources/remote/user_datasource.dart';
import 'package:sum_plus/data/datasources/local/user_local_datasource.dart';
import 'package:sum_plus/data/utils/network_util.dart';

import 'package:sum_plus/domain/models/user.dart';
import 'package:sum_plus/domain/repositories/user_repository.dart';

class UserRetoolRepository implements UserRepository {
  final UserDatasource _userDatasource = UserDatasource();
  final UserLocalDatasource _userLocalDatasource = UserLocalDatasource();

  final String baseUri = 'https://retoolapi.dev/0zLAjT/sum-plus';

  @override
  Future<User> getUser(String? email) async {
    User? user = await _userLocalDatasource.getUser();
    if (user != null) {
      return user;
    } else if (email != null) {
      user = await _userDatasource.getUser(baseUri, email);
      _userLocalDatasource.setUser(user).catchError((err) {
        logError(err);
      });
      return user;
    } else {
      return Future.error('User not found');
    }
  }

  @override
  Future<User> addUser(User user) async {
    final User newUser = await _userDatasource.addUser(baseUri, user);
    _userLocalDatasource.setUser(newUser).catchError((err) {
      logError(err);
    });
    return newUser;
  }

  @override
  Future<User> updateUser(User user) async {
    if (await NetworkUtil.hasNetwork()) {
      final User updatedUser = await _userDatasource.updateUser(baseUri, user);
      _userLocalDatasource.updateUser(updatedUser).catchError((err) {
        logError(err);
      });
      return updatedUser;
    } else {
      return await _userLocalDatasource.updateUser(user);
    }
  }

  @override
  Future<User> updatePartialUser(int id,
      {String? firstName,
      String? lastName,
      String? email,
      String? birthDate,
      String? degree,
      String? school,
      int? level}) async {
    if (await NetworkUtil.hasNetwork()) {
      final User updatedUser = await _userDatasource.updatePartialUser(
          baseUri, id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          birthDate: birthDate,
          degree: degree,
          school: school,
          level: level);
      _userLocalDatasource.setUser(updatedUser).catchError((err) {
        logError(err);
      });
      return updatedUser;
    } else {
      final User updatedUser = await _userLocalDatasource.updatePartialUser(id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          birthDate: birthDate,
          degree: degree,
          school: school,
          level: level);
      return updatedUser;
    }
  }

  @override
  Future<bool> removeUser() async {
    if (await _userLocalDatasource.containsUser()) {
      return await _userLocalDatasource.removeUser();
    } else {
      return true;
    }
  }
}
