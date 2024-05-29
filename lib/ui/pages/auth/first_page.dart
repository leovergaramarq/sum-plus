import 'package:loggy/loggy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sum_plus/ui/pages/auth/login_page.dart';
import 'package:sum_plus/ui/pages/content/home_page.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);

  @override
  FirstPageState createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();
  final QuestionController _questionController = Get.find<QuestionController>();

  void onStart() async {
    if (_authController.isLoggedIn && _userController.isUserFetched) {
      _questionController.setLevel(_userController.user.level!);
      Get.off(
        () => HomePage(
          key: const Key('HomePage'),
        ),
      );
    } else {
      try {
        await Future.wait([
          if (_authController.isLoggedIn) _authController.logOut(),
          if (_userController.isUserFetched) _userController.resetUser(),
          if (_sessionController.areSessionsFetched)
            _sessionController.resetSessions(),
        ]);
      } catch (err) {
        logError(err);
      }
      _questionController.resetLevel();
      Get.to(
        () => const LoginPage(
          key: Key('LoginPage'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/First.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sum+',
                  style: TextStyle(
                    fontFamily: 'Itim',
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  key: const Key('LoginButton'),
                  onPressed: onStart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    minimumSize: const Size(200, 48),
                  ),
                  child: const Text(
                    'Let\'s start!',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Inter',
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
