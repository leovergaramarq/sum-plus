import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';

import 'package:sum_plus/ui/pages/auth/login_page.dart';
import 'package:sum_plus/ui/utils/auth_util.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  AppBarWidget(
      {Key? key,
      this.text = '',
      this.backButton = false,
      this.logoutButton = false})
      : super(key: key);

  final AuthUtil _authUtil = AuthUtil();

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();
  final QuestionController _questionController = Get.find<QuestionController>();

  final String text;
  final bool backButton;
  final bool logoutButton;

  Future<void> onLogout(BuildContext context) async {
    if (!(await _authUtil.validateLogout(context))) return;

    _authController.logOut().catchError((e) => print(e));

    if (_userController.isUserFetched) {
      _userController.resetUser().catchError((e) => print(e));
    }
    if (_sessionController.areSessionsFetched) {
      _sessionController.resetSessions().catchError((e) => print(e));
    }
    _questionController.resetLevel();

    // await (await SharedPreferences.getInstance()).clear(); // clear localStorage on logout for debugging

    Get.offAll(() => const LoginPage(
          key: Key('LoginPage'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(text),
      centerTitle: true,
      actions: [
        if (logoutButton)
          IconButton(
              key: const Key('ButtonHomeLogOff'),
              onPressed: () => onLogout(context),
              icon: const Icon(Icons.logout))
      ],
      automaticallyImplyLeading: backButton,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
