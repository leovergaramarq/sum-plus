import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sum_plus/domain/models/session.dart';

class SessionLocalDatasource {
  // SessionLocalDatasource() {
  //   SharedPreferences.getInstance().then((value) => prefs = value);
  // }

  final int maxSessions = 100;
  final String sessionsKey = 'sessions';
  SharedPreferences? prefs;

  Future<List<Session>> getSessions({int? limit}) async =>
      (await _getSessionsStoreFromUser()).map((e) => e.data).toList();

  Future<List<SessionStore>> getSessionsStore({int? limit}) async =>
      await _getSessionsStoreFromUser(limit: limit);

  Future<Session> addSession(bool isUpToDate, Session session) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    List<SessionStore> sessionsStore = await _getSessionsStoreFromUser();
    if (sessionsStore.length >= maxSessions) {
      sessionsStore = sessionsStore
          .getRange(
              sessionsStore.length - (maxSessions - 1), sessionsStore.length)
          .toList();
    }

    final sessionStore = SessionStore(session, isUpToDate);
    sessionsStore.add(
        sessionStore); // Here sessions.length must be less or equal to maxSessions

    final String sessionsString =
        jsonEncode(sessionsStore.map((e) => e.toJson()).toList());

    await prefs!.setString(sessionsKey, sessionsString);
    return session;
  }

  Future<void> setSessionsStore(List<SessionStore> sessionsStore,
      {bool replaceNotUpToDate = false}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    if (!replaceNotUpToDate) {
      List<SessionStore> missingSessions = (await _getSessionsStoreFromUser())
          .where((e) => !e.isUpToDate)
          .toList();
      if (missingSessions.isNotEmpty) {
        sessionsStore = [...sessionsStore, ...missingSessions];
      }
    }

    final String sessionsString =
        jsonEncode(sessionsStore.map((e) => e.toJson()).toList());

    await prefs!.setString(sessionsKey, sessionsString);
  }

  Future<void> setSessions(bool isUpToDate, List<Session> sessions,
      {bool replaceNotUpToDate = false}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    List<SessionStore> sessionsStore =
        sessions.map((e) => SessionStore(e, isUpToDate)).toList();

    if (!replaceNotUpToDate) {
      List<SessionStore> missingSessions = (await _getSessionsStoreFromUser())
          .where((e) => !e.isUpToDate)
          .toList();
      if (missingSessions.isNotEmpty) {
        sessionsStore = [...sessionsStore, ...missingSessions];
      }
    }

    final String sessionsString =
        jsonEncode(sessionsStore.map((e) => e.toJson()).toList());

    await prefs!.setString(sessionsKey, sessionsString);
  }

  Future<List<SessionStore>> _getSessionsStoreFromUser({int? limit}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    final String? sessionsStoreString = prefs!.getString(sessionsKey);
    if (sessionsStoreString == null) return [];

    final List<dynamic> sessionsStoreMap = jsonDecode(sessionsStoreString);

    List<SessionStore> sessions =
        sessionsStoreMap.map((e) => SessionStore.fromJson(e)).toList();

    if (limit == null || limit >= sessions.length) return sessions;

    return sessions.getRange(sessions.length - limit, sessions.length).toList();
  }

  Future<bool> removeSessions() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return await prefs!.remove(sessionsKey);
  }

  Future<bool> containsSessions() async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    return prefs!.containsKey(sessionsKey);
  }
}

class SessionStore {
  SessionStore(this.data, this.isUpToDate);

  Session data;
  bool isUpToDate; // whether the data is updated in the backend

  factory SessionStore.fromJson(Map<String, dynamic> json) => SessionStore(
        Session.fromJson(json["data"]),
        json["isUpToDate"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "isUpToDate": isUpToDate,
      };
}
