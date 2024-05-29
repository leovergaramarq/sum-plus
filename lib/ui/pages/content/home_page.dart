import 'package:loggy/loggy.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sum_plus/domain/models/session.dart';
import 'dart:math';

import 'package:sum_plus/ui/pages/content/quest_page.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/bottom_nav_bar_widget.dart';
import 'package:sum_plus/ui/widgets/level_stars_widget.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';

import 'package:sum_plus/domain/models/answer.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, this.fetchSessions = true}) : super(key: key);
  final bool fetchSessions;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final AuthController _authController = Get.find<AuthController>();
  final QuestionController _questionController = Get.find<QuestionController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();

  @override
  void initState() {
    if (widget.fetchSessions) {
      _sessionController
          .getSessionsFromUser(
              _authController.isLoggedIn ? _userController.user.email : null,
              limit: _sessionController.numSummarizeSessions)
          .catchError((err) {
        logError(err);
        return [] as List<Session>;
      });
    }
    super.initState();
  }

  Widget sessionsSummaryWidget() {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 32),
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
          const SizedBox(height: 16),
          Obx(() {
            if (!_sessionController.areSessionsFetched) {
              return const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              );
            }

            if (_sessionController.sessions.isEmpty) {
              return const Text(
                  'Start your exercise to initiate your progress!',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic));
            }

            int avgSeconds = _sessionController.sessions.fold(
                    0,
                    (previousValue, element) =>
                        previousValue + element.totalSeconds) ~/
                _sessionController.sessions.length;

            int totalAnswers = _sessionController.sessions.fold(0,
                (previousValue, element) => previousValue + element.numAnswers);

            int totalCorrectAnswers = _sessionController.sessions.fold(
                0,
                (previousValue, element) =>
                    previousValue + element.numCorrectAnswers);

            int correctPercentage =
                (totalCorrectAnswers / totalAnswers * 100).round();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(Icons.av_timer, size: 36, color: Colors.grey.shade700),
                    Text(
                      'Average time per session: ${Answer.formatTime(avgSeconds)}',
                      style:
                          TextStyle(fontSize: 18, color: Colors.grey.shade700),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.task_outlined,
                      size: 36,
                      color: Colors.grey.shade700,
                    ),
                    Text(
                        'Success: $totalCorrectAnswers/$totalAnswers ($correctPercentage%)',
                        style: TextStyle(
                            fontSize: 18, color: Colors.grey.shade700))
                  ],
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      fontSize: 28,
                      fontFamily: 'Itim',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 32, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Align(
                                alignment: Alignment.center,
                                child: Image.asset(
                                  'assets/img/exercise_bg2.png',
                                  width: 128,
                                  height: 128,
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
                        ElevatedButton(
                          key: const Key('StartButton'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
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
                              style: const TextStyle(
                                fontSize: 25,
                                fontFamily: 'Itim',
                              ))),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 56),
              sessionsSummaryWidget(),
            ],
          ),
        ),
      ),
      bottomNavigationBar:
          BottomNavBarWidget(section: BottomNavBarWidgetSection.home),
    );
  }
}
