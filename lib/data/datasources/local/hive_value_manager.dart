import 'package:hive_flutter/hive_flutter.dart';
import 'package:loggy/loggy.dart';

class HiveValueManager {
  HiveValueManager(this._key, this._domain);

  final String _key;
  final String _domain;

  String? getValue() {
    return Hive.box(_domain).get(_key, defaultValue: null);
  }

  Future<bool> putValue(String value) async {
    try {
      await Hive.box(_domain).put(_key, value);
      return true;
    } catch (err) {
      logError('Error putting value', err);
      return false;
    }
  }

  Future<bool> removeValue() async {
    try {
      await Hive.box(_domain).delete(_key);
      return true;
    } catch (err) {
      logError('Error removing value', err);
      return false;
    }
  }
}
