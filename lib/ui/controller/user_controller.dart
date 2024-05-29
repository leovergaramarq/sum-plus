import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:sum_plus/domain/use_case/user_use_case.dart';
import 'package:sum_plus/domain/models/user.dart';

class UserController extends GetxController {
  final UserUseCase _userUseCase = UserUseCase();
  final Rx<User> _user = Rx<User>(User.defaultUser());
  final RxBool _isUserFetched = RxBool(false);

  User get user => _user.value;
  bool get isUserFetched => _isUserFetched.value;

  @override
  void onInit() async {
    super.onInit();
    try {
      await getUser(null);
    } catch (e) {
      print(e);
    }
  }

  Future<void> getUser(String? email) async {
    logInfo("Getting user");
    _user.value = await _userUseCase.getUser(email);
    _isUserFetched.value = true;
  }

  Future<User> addUser(User user) async {
    logInfo("Add user");
    User newUser = await _userUseCase.addUser(user);
    _user.value = newUser;
    return newUser;
  }

  Future<User> updateUser(User user) async {
    logInfo("Update user");
    if (user.id == null) {
      return Future.error('User id is null');
    }
    User updatedUser = await _userUseCase.updateUser(user);
    _user.value = updatedUser;
    return updatedUser;
  }

  Future<User> updatePartialUser(
      {String? firstName,
      String? lastName,
      String? email,
      String? birthDate,
      String? degree,
      String? school,
      int? level}) async {
    logInfo("Update user");
    if (user.id == null) {
      return Future.error('User id is null');
    }
    User updatedUser = await _userUseCase.updatePartialUser(user.id!,
        firstName: firstName,
        lastName: lastName,
        email: email,
        birthDate: birthDate,
        degree: degree,
        school: school,
        level: level);
    _user.value = updatedUser;
    return updatedUser;
  }

  Future<void> resetUser() async {
    await _userUseCase.removeUser();
    _user.value = User.defaultUser();
    _isUserFetched.value = false;
  }
}
