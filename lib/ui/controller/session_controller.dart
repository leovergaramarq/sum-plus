import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:sum_plus/domain/use_case/session_use_case.dart';
import 'package:sum_plus/domain/models/session.dart';

class SessionController extends GetxController {
  final SessionUseCase _sessionUseCase = SessionUseCase();

  // states
  final Rx<List<Session>> _sessions = Rx<List<Session>>([]);
  final RxBool _areSessionsFetched = RxBool(false);

  List<Session> get sessions => _sessions.value;
  bool get areSessionsFetched => _areSessionsFetched.value;
  int get numSummarizeSessions => _sessionUseCase.numSummarizeSessions;

  Future<List<Session>> getSessionsFromUser(String? userEmail,
      {int? limit, String? sort, String? order}) async {
    logInfo("Getting sessions");
    if (areSessionsFetched) _areSessionsFetched.value = false;
    List<Session> sessions = await _sessionUseCase
        .getSessionsFromUser(userEmail, limit: limit, sort: sort, order: order);
    _sessions.value = sessions;
    _areSessionsFetched.value = true;
    return sessions;
  }

  Future<Session> addSession(Session session) async {
    logInfo("Add session");
    Session newSession = await _sessionUseCase.addSession(session);
    _sessions.value.add(newSession);
    _sessions.refresh();
    return newSession;
  }

  Future<void> resetSessions() async {
    await _sessionUseCase.removeSessions();
    _sessions.value = [];
    _areSessionsFetched.value = false;
  }
}
