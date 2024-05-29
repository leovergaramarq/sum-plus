// import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:sum_plus/data/datasources/local/hive_value_manager.dart';

class AuthLocalDatasource {
  AuthLocalDatasource() {
    _hiveTokenManager = HiveValueManager(tokenKey, _domain);
  }
  final String _domain = 'flutter.domain.auth';
  final String tokenKey = 'flutter.authToken';
  bool _boxOpened = false;
  late HiveValueManager _hiveTokenManager;

  Future<bool> saveToken(String token) async {
    if (!_boxOpened) await _openBox();
    return await _hiveTokenManager.putValue(token);
  }

  Future<bool> removeToken() async {
    if (!_boxOpened) await _openBox();
    return await _hiveTokenManager.removeValue();
  }

  Future<bool> containsToken() async {
    if (!_boxOpened) await _openBox();
    return _hiveTokenManager.getValue() != null;
  }

  Future<void> _openBox() async {
    await Hive.openBox(_domain);
    _boxOpened = true;
  }
}
