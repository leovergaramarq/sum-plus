// import 'package:get/get.dart';

// import 'package:uninorte_mobile_class_project/domain/repositories/session_repository.dart';
import 'package:uninorte_mobile_class_project/data/repositories/session_retool_repository.dart';
import 'package:uninorte_mobile_class_project/domain/models/session.dart';

class SessionUseCase {
  // final SessionRetoolRepository _sessionRepository =
  //     Get.find<SessionRetoolRepository>();
  final SessionRetoolRepository _sessionRepository = SessionRetoolRepository();

  // static fields
  final int numSummarizeSessions = 5;

  Future<List<Session>> getSessionsFromUser(String? userEmail,
          {int? limit, String? sort, String? order}) async =>
      await _sessionRepository.getSessionsFromUser(userEmail,
          limit: limit, sort: sort, order: order);

  Future<Session> addSession(Session session) async =>
      await _sessionRepository.addSession(session);

  Future<bool> removeSessions() async =>
      await _sessionRepository.removeSessions();
}
