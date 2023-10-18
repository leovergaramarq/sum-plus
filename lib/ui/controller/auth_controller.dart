import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:uninorte_mobile_class_project/domain/use_case/auth_use_case.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  // AuthController(): super() {
  //   _isLoggedIn.value = _authUseCase.isLoggedIn();
  // }

  final AuthUseCase _authUseCase = AuthUseCase();
  final RxBool _isLoggedIn = RxBool(false);
  final RxBool _isGuest = RxBool(false);

  bool get isLoggedIn => _isLoggedIn.value;
  bool get isGuest => _isGuest.value;

  @override
  void onInit() async {
    super.onInit();
    _isLoggedIn.value = await _authUseCase.isLoggedIn();
  }

  Future<void> login(email, password) async {
    await _authUseCase.login(email, password);
    _isLoggedIn.value = true;
    if (_isGuest.value) _isGuest.value = false;
  }

  Future<void> signUp(email, password) async {
    logInfo('Controller Sign Up');
    await _authUseCase.signUp(email, password);
    _isLoggedIn.value = true;
    if (_isGuest.value) _isGuest.value = false;
  }

  Future<void> logOut() async {
    print('Logging out');
    await _authUseCase.logOut();
    _isLoggedIn.value = false;
    _isGuest.value = false;
  }

  void continueAsGuest() {
    _isGuest.value = true;
    if (_isLoggedIn.value) _isLoggedIn.value = false;
  }

  void setLoggedIn() {
    _isLoggedIn.value = true;
    if (_isGuest.value) _isGuest.value = false;
  }
}
