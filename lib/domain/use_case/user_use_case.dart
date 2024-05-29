// import 'package:get/get.dart';

// import 'package:sum_plus/domain/repositories/user_repository.dart';
import 'package:sum_plus/data/repositories/user_retool_repository.dart';
import 'package:sum_plus/domain/models/user.dart';

class UserUseCase {
  // final UserRetoolRepository _userRepository = Get.find<UserRetoolRepository>();
  final UserRetoolRepository _userRepository = UserRetoolRepository();

  Future<User> getUser(String? email) async {
    return await _userRepository.getUser(email);
  }

  Future<User> addUser(User user) async => await _userRepository.addUser(user);

  Future<User> updateUser(User user) async =>
      await _userRepository.updateUser(user);

  Future<User> updatePartialUser(int id,
          {String? firstName,
          String? lastName,
          String? email,
          String? birthDate,
          String? degree,
          String? school,
          int? level}) async =>
      await _userRepository.updatePartialUser(id,
          firstName: firstName,
          lastName: lastName,
          email: email,
          birthDate: birthDate,
          degree: degree,
          school: school,
          level: level);

  Future<void> removeUser() async => await _userRepository.removeUser();
}
