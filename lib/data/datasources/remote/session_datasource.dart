import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:sum_plus/domain/models/session.dart';
import 'package:http/http.dart' as http;

class SessionDatasource {
  Future<List<Session>> getSessionsFromUser(String baseUri, String userEmail,
      {int? limit, String? sort, String? order}) async {
    List<Session> sessions = [];
    final Uri request = Uri.parse(baseUri).resolveUri(Uri(queryParameters: {
      "format": 'json',
      "userEmail": userEmail,
      if (limit != null) "_limit": limit.toString(),
      if (sort != null) "_sort": sort,
      if (order != null) "_order": order,
    }));

    try {
      final http.Response response = await http.get(request);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        sessions = List<Session>.from(data.map((x) => Session.fromJson(x)));
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.error('Error code ${response.statusCode}');
      }

      return Future.value(sessions);
    } catch (err) {
      logError("Got error $err");
      return Future.error(err);
    }
  }

  Future<Session> addSession(String baseUri, Session session) async {
    logInfo("Web service, Adding session");

    try {
      final response = await http.post(
        Uri.parse(baseUri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(session.toJson()),
      );

      if (response.statusCode == 201) {
        //logInfo(response.body);
        return Future.value(Session.fromJson(jsonDecode(response.body)));
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.error('Error code ${response.statusCode}');
      }
    } catch (err) {
      logError("Got error $err");
      return Future.error(err);
    }
  }
}
