import 'package:get/get.dart';

import 'package:sum_plus/domain/repositories/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _authRepository = Get.find<AuthRepository>();

  Future<String> login(String email, String password) async =>
      await _authRepository.login(email, password);

  Future<void> signUp(String email, String password) async =>
      await _authRepository.signUp(email, password);

  Future<void> logOut() async => await _authRepository.logOut();

  Future<bool> isLoggedIn() async => await _authRepository.isLoggedIn();
}
