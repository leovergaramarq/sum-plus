import 'dart:convert';
import 'package:loggy/loggy.dart';
import 'package:http/http.dart' as http;

import 'package:sum_plus/domain/models/user.dart';

class UserDatasource {
  Future<User> getUser(String baseUri, String email) async {
    final Uri request = Uri.parse(baseUri).resolveUri(Uri(queryParameters: {
      "format": 'json',
      "email": email,
    }));

    try {
      final http.Response response = await http.get(request);

      if (response.statusCode == 200) {
        //logInfo(response.body);
        final data = jsonDecode(response.body);

        List<User> users = List<User>.from(data.map((x) => User.fromJson(x)));
        if (users.isNotEmpty) return users[0];
        return Future.error('User not found');
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.error('Error code ${response.statusCode}');
      }
    } catch (err) {
      logError("Got error $err");
      return Future.error(err);
    }
  }

  Future<User> addUser(String baseUri, User user) async {
    logInfo("Web service, Adding user");

    try {
      final response = await http.post(
        Uri.parse(baseUri),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        //logInfo(response.body);
        return Future.value(User.fromJson(jsonDecode(response.body)));
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.error('Error code ${response.statusCode}');
      }
    } catch (err) {
      logError("Got error $err");
      return Future.error(err);
    }
  }

  Future<User> updateUser(String baseUri, User user) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUri/${user.id}"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        //logInfo(response.body);
        return Future.value(User.fromJson(jsonDecode(response.body)));
      } else {
        logError("Got error code ${response.statusCode}");
        return Future.error('Error code ${response.statusCode}');
      }
    } catch (err) {
      logError("Got error $err");
      return Future.error(err);
    }
  }

  Future<User> updatePartialUser(String baseUri, int id,
      {String? firstName,
      String? lastName,
      String? email,
      String? birthDate,
      String? degree,
      String? school,
      int? level}) async {
    try {
      final response = await http.patch(
        Uri.parse("$baseUri/$id"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            if (firstName != null) 'firstName': firstName,
            if (lastName != null) 'lastName': lastName,
            if (email != null) 'email': email,
            if (birthDate != null) 'birthDate': birthDate,
            if (degree != null) 'degree': degree,
            if (school != null) 'school': school,
            if (level != null) 'level': level,
          },
        ),
      );

      if (response.statusCode == 200) {
        //logInfo(response.body);
        return Future.value(User.fromJson(jsonDecode(response.body)));
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
