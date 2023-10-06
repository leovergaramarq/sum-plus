// import 'dart:async';
import 'package:uninorte_mobile_class_project/data/datasources/remote/session_datasource.dart';
import 'package:uninorte_mobile_class_project/data/datasources/local/session_local_datasource.dart';
import 'package:uninorte_mobile_class_project/data/utils/network_util.dart';

import 'package:uninorte_mobile_class_project/domain/models/session.dart';
import 'package:uninorte_mobile_class_project/domain/repositories/session_repository.dart';

class SessionRetoolRepository implements SessionRepository {
  final SessionDatasource _sessionDatasource = SessionDatasource();
  final SessionLocalDatasource _sessionLocalDatasource =
      SessionLocalDatasource();

  final String baseUri = 'https://retoolapi.dev/0fkNBk/sum-plus';

  @override
  Future<List<Session>> getSessionsFromUser(String? userEmail,
      {int? limit, String? sort, String? order}) async {
    bool lastNetworkCheck = NetworkUtil.lastNetworkCheck;

    if (await NetworkUtil.hasNetwork(baseUri) && userEmail != null) {
      if (!lastNetworkCheck) await checkMissingLocalSessions();
      List<Session> sessions = await _sessionDatasource.getSessionsFromUser(
        baseUri,
        userEmail,
        limit: limit,
        sort: sort,
        order: order,
      );
      _sessionLocalDatasource.setSessions(true, sessions);
      return sessions;
    } else {
      return _sessionLocalDatasource.getSessions();
    }
  }

  @override
  Future<Session> addSession(Session session) async {
    bool lastNetworkCheck = NetworkUtil.lastNetworkCheck;

    if (await NetworkUtil.hasNetwork(baseUri)) {
      if (!lastNetworkCheck) await checkMissingLocalSessions();
      final Session newSession =
          await _sessionDatasource.addSession(baseUri, session);

      // _sessionDatasource
      //     .getSessionsFromUser(
      //       baseUri,
      //       session.userEmail,
      //     )
      //     .then(
      //         (sessions) => _sessionLocalDatasource.setSessions(true, sessions))
      //     .catchError((e) => print(e));

      _sessionLocalDatasource.addSession(true, newSession);

      return newSession;
    } else {
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
        print('Missing session added!');
        e.data = newSession;
        e.isUpToDate = true;
        return true;
      } catch (e) {
        print(e);
        return false;
      }
    }).toList();

    try {
      List<bool> processed = await Future.wait(futures);
      if (processed.contains(true)) {
        await _sessionLocalDatasource.setSessionsStore(sessionsStore,
            replaceNotUpToDate: true);
        print('Missing sessions updated locally!');
      }
    } catch (e) {
      print(e);
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
