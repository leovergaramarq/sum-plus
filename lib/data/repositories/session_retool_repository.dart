import 'dart:convert';

import 'package:loggy/loggy.dart';

import 'package:sum_plus/data/datasources/remote/session_datasource.dart';
import 'package:sum_plus/data/datasources/local/session_local_datasource.dart';
// import 'package:sum_plus/data/utils/network_util.dart';

import 'package:sum_plus/domain/models/session.dart';
import 'package:sum_plus/domain/repositories/session_repository.dart';

class SessionRetoolRepository implements SessionRepository {
  final SessionDatasource _sessionDatasource = SessionDatasource();
  final SessionLocalDatasource _sessionLocalDatasource =
      SessionLocalDatasource();

  final String baseUri = 'https://retoolapi.dev/0fkNBk/sum-plus';

  @override
  Future<List<Session>> getSessionsFromUser(String? userEmail,
      {int? limit, String? sort, String? order}) async {
    if (userEmail != null) {
      try {
        List<Session> sessions = await _sessionDatasource.getSessionsFromUser(
          baseUri,
          userEmail,
          limit: limit,
          sort: sort,
          order: order,
        );
        _sessionLocalDatasource.setSessions(true, sessions).catchError((err) {
          logError(err);
        });
        return sessions;
      } catch (err) {
        logError(err);
        return _sessionLocalDatasource.getSessions();
      }
    } else {
      return _sessionLocalDatasource.getSessions();
    }
  }

  @override
  Future<Session> addSession(Session session) async {
    try {
      final Session newSession =
          await _sessionDatasource.addSession(baseUri, session);

      _sessionLocalDatasource.addSession(true, newSession).catchError((err) {
        logError(err);
        return newSession;
      });

      return newSession;
    } catch (err) {
      logError(err);
      return await _sessionLocalDatasource.addSession(false, session);
    }
  }

  Future<void> checkMissingLocalSessions() async {
    final List<SessionStore> sessionsStore =
        await _sessionLocalDatasource.getSessionsStore();
    final List<SessionStore> missingSessions =
        sessionsStore.where((e) => !e.isUpToDate).toList();
    if (missingSessions.isEmpty) return;

    final List<Future<bool>> futures =
        missingSessions.map<Future<bool>>((e) async {
      try {
        Session newSession =
            await _sessionDatasource.addSession(baseUri, e.data);
        logInfo('Missing session added!');
        e.data = newSession;
        e.isUpToDate = true;
        return true;
      } catch (err) {
        logError(err);
        return false;
      }
    }).toList();

    try {
      List<bool> processed = await Future.wait(futures);
      if (processed.contains(true)) {
        await _sessionLocalDatasource.setSessionsStore(sessionsStore,
            replaceNotUpToDate: true);
        logInfo('Missing sessions updated locally!');
      }
    } catch (err) {
      logError(err);
    }
  }

  @override
  Future<bool> removeSessions() async {
    if (await _sessionLocalDatasource.containsSessions()) {
      return await _sessionLocalDatasource.removeSessions();
    } else {
      return true;
    }
  }
}
