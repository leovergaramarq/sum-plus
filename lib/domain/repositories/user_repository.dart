import 'package:uninorte_mobile_class_project/domain/models/user.dart';

abstract class UserRepository {
  Future<User> getUser(String email);

  Future<User> addUser(User user);

  Future<User> updateUser(User user);

  Future<User> updatePartialUser(int id,
      {String? firstName,
      String? lastName,
      String? email,
      String? birthDate,
      String? degree,
      String? school,
      int? level});
}
