import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

// import 'package:sum_plus/ui/pages/auth/login_page.dart';
import 'package:sum_plus/ui/pages/content/quest_page.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/bottom_nav_bar_widget.dart';
import 'package:sum_plus/ui/widgets/level_stars_widget.dart';
import 'package:sum_plus/ui/utils/auth_util.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';

import 'package:sum_plus/domain/models/answer.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key, this.fetchSessions = true}) : super(key: key);
  bool fetchSessions;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AuthController _authController = Get.find<AuthController>();
  final QuestionController _questionController = Get.find<QuestionController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();

  @override
  void initState() {
    if (widget.fetchSessions && _authController.isLoggedIn) {
      _sessionController
          .getSessionsFromUser(_userController.user.email,
              limit: _sessionController.numSummarizeSessions)
          .catchError((e) => print(e));
    }
    super.initState();
  }

  Widget SessionsSummaryWidget() {
    return Column(
      children: [
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(6, 8, 6, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                int numSessionsShown = _sessionController.areSessionsFetched
                    ? _sessionController.sessions.length
                    : _sessionController.numSummarizeSessions;
                String message;
                if (numSessionsShown == 0) {
                  message = 'No sessions yet';
                } else if (numSessionsShown == 1) {
                  message = 'Last session';
                } else {
                  message = 'Last $numSessionsShown sessions';
                }

                return Text(
                  message,
                  style: const TextStyle(fontSize: 22),
                );
              }),
              SizedBox(height: 16),
              Obx(() {
                // print(
                //     '_sessionController.areSessionsFetched ${_sessionController.areSessionsFetched}');
                if (!_sessionController.areSessionsFetched) {
                  return const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [CircularProgressIndicator()],
                  );
                }

                if (_sessionController.sessions.isEmpty) {
                  return const Text('No sessions yet');
                }

                int avgSeconds = _sessionController.sessions.fold(
                        0,
                        (previousValue, element) =>
                            previousValue + element.totalSeconds) ~/
                    _sessionController.sessions.length;

                int totalAnswers = _sessionController.sessions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.numAnswers);

                int totalCorrectAnswers = _sessionController.sessions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.numCorrectAnswers);

                int correctPercentage =
                    (totalCorrectAnswers / totalAnswers * 100).round();

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.av_timer,
                          size: 36,
                          color: Color(0x3C3C3C).withOpacity(1),
                        ),
                        Text(
                          'Average time per session: ${Answer.formatTime(avgSeconds)}',
                          style: const TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 36,
                          color: Color(0x3C3C3C).withOpacity(1),
                        ),
                        Text(
                            'Success: $totalCorrectAnswers/$totalAnswers ($correctPercentage%)',
                            style: const TextStyle(fontSize: 18))
                      ],
                    ),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                );
              })
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    // SharedPreferences.getInstance().then((prefs) async {
    //   print(prefs.getString('user'));
    // });
    return Scaffold(
      backgroundColor: Color(0xF2F2F2).withOpacity(1),
      appBar: AppBarWidget(text: 'Home', logoutButton: true),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _authController.isLoggedIn
                        ? 'Hello, ${_userController.user.email}!'
                        : 'Welcome to Sum+',
                    style: const TextStyle(
                      fontSize: 24,
                      fontFamily: 'Itim',
                    ),
                  ),
                  // const SizedBox(
                  //   height: 24,
                  // ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/img/exercise_bg.png',
                                width: 180,
                                height: 180,
                              ),
                            ),
                            Obx(() => LevelStarsWidget(
                                  level: min(_questionController.level,
                                      _questionController.maxLevel),
                                  starSize: 36,
                                ))
                          ],
                        ),
                      ),
                      // const SizedBox(
                      //   width: 24,
                      // ),
                      ElevatedButton(
                        key: const Key('StartButton'),
                        style: ElevatedButton.styleFrom(
                          // primary: Color(0xFF997AC1),
                          padding: const EdgeInsets.fromLTRB(32, 16, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () {
                          Get.to(() => const QuestPage(
                                key: Key('QuestPage'),
                              ));
                        },
                        child: Obx(() => Text(
                            // _sessionController.areSessionsFetched &&
                            _sessionController.sessions.isNotEmpty
                                ? 'Continue'
                                : 'Let\'s go!',
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: 'Itim',
                            ))),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 56),
              if (_authController.isLoggedIn) SessionsSummaryWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavBarWidget(section: BottomNavBarWidgetSection.home),
    );
  }
}
