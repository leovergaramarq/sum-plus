import 'dart:convert';

import 'package:get/get.dart';

import 'package:sum_plus/domain/repositories/session_repository.dart';
import 'package:sum_plus/domain/models/session.dart';

class SessionUseCase {
  final SessionRepository _sessionRepository = Get.find<SessionRepository>();

  // static fields
  final int numSummarizeSessions = 5;

  Future<List<Session>> getSessionsFromUser(String? userEmail,
      {int? limit, String? sort, String? order}) async {
    List<Session> sessions = await _sessionRepository
        .getSessionsFromUser(userEmail, limit: limit, sort: sort, order: order);
    return sessions;
  }

  Future<Session> addSession(Session session) async =>
      await _sessionRepository.addSession(session);

  Future<bool> removeSessions() async =>
      await _sessionRepository.removeSessions();
}
