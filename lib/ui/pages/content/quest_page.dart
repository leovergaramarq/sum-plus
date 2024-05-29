import 'package:loggy/loggy.dart';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sum_plus/ui/pages/content/session_summary_page.dart';

import 'package:sum_plus/ui/widgets/answer_typing_widget.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/question_widget.dart';
import 'package:sum_plus/ui/widgets/numpad_widget.dart';
import 'package:sum_plus/ui/widgets/level_stars_widget.dart';

import 'package:sum_plus/ui/controller/question_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';

import 'package:sum_plus/domain/models/answer.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  QuestPageState createState() => QuestPageState();
}

class QuestPageState extends State<QuestPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final QuestionController _questionController = Get.find<QuestionController>();
  final AuthController _authController = Get.find<AuthController>();
  final SessionController _sessionController = Get.find<SessionController>();
  final UserController _userController = Get.find<UserController>();

  Timer _answerTimer = Timer(const Duration(), () {});
  StreamSubscription<int>? _levelListener;

  @override
  void initState() {
    super.initState();
    _questionController.startSession(_userController.user.email);
    nextQuestion();
    if (_authController.isLoggedIn) {
      _levelListener = _questionController.listenLevel((level) async {
        if (level == _userController.user.level) return;
        try {
          await _userController.updatePartialUser(level: level);
        } catch (err) {
          logError(err);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _answerTimer.cancel();
    if (_levelListener != null) {
      try {
        _levelListener!.cancel();
      } catch (err) {
        logError(err);
      }
    }
  }

  void nextQuestion() {
    if (_questionController.userAnswer != 0) _questionController.clearAnswer();
    bool nextQuestionObtained = _questionController.nextQuestion();

    if (nextQuestionObtained) {
      if (_answerTimer.isActive) _answerTimer.cancel();
      _questionController.setAnswerSeconds(0);

      _answerTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        _questionController.setAnswerSeconds(timer.tick);
      });
    } else {
      // There aren't more questions
      _questionController.wrapSessionUp();

      _sessionController
          .addSession(_questionController.session)
          .catchError((err) {
        logError(err);
      });
      Get.off(() => const SessionSummaryPage(
            key: Key('SessionSummaryPage'),
          ));
    }
  }

  void changeQuestion() {
    if (!_questionController.didAnswer) nextQuestion();
  }

  Widget optionalContinueWidget() {
    return Obx(() {
      if (_questionController.didAnswer) {
        return Column(
          children: [
            const SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: nextQuestion,
              child: const Text('Next', style: TextStyle(fontSize: 20)),
            )
          ],
        );
      } else {
        return Container(
          height: 20,
        );
      }
    });
  }

  Widget questionOrLoadWidget() {
    return Obx(() {
      if (_questionController.isQuestionReady) {
        return QuestionWidget(question: _questionController.question);
      } else {
        return const CircularProgressIndicator();
      }
    });
  }

  void typeNumber(int number) {
    if (_questionController.didAnswer ||
        _questionController.userAnswer.toString().length >=
            _questionController.maxLevel + 1) return;
    _questionController.typeNumber(number);
  }

  void clearAnswer() {
    _questionController.clearAnswer();
  }

  void answer() {
    BuildContext context;
    try {
      context = _scaffoldKey.currentContext!;
    } catch (err) {
      logError(err);
      return;
    }
    if (!_questionController.isQuestionReady) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Question was not loaded yet. Try again.'),
        duration: Duration(seconds: 2),
      ));
    } else if (_questionController.didAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('You already answered this question'),
        duration: Duration(seconds: 2),
      ));
    } else {
      _answerTimer.cancel();
      _questionController.answer(_questionController.answerSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (willPop) async {
        if (!willPop) return;

        bool leaveSession = await Future<bool>(() async =>
            await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: const Text("Are you sure?"),
                      content: const Text(
                          "If you go back, the current session will not be saved."),
                      actions: [
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: const Text("Continue"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    )) ??
            false);
        if (leaveSession) _questionController.cancelSesion();
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBarWidget(
          text: 'Exercise',
          backButton: true,
          logoutButton: false,
        ),
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 48),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        int numQuestion =
                            _questionController.session.answers.length;
                        if (!_questionController.didAnswer) numQuestion += 1;
                        return Text(
                          'Question $numQuestion/${_questionController.questionsPerSession}',
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        );
                      }),
                      Column(
                        children: [
                          const Text(
                            'Level',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w500),
                          ),
                          Obx(() => LevelStarsWidget(
                                level: min(_questionController.level,
                                    _questionController.maxLevel),
                              )),
                        ],
                      ),
                      Obx(() => Text(
                            'Time: ${Answer.formatTime(_questionController.answerSeconds)}',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w500),
                          )),
                    ],
                  ),
                  questionOrLoadWidget(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 300, 0),
                        child: Text(
                          '=',
                          style: TextStyle(fontSize: 56),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(300, 0, 0, 0),
                        child: Obx(() {
                          if (_questionController.didAnswer) {
                            if (_questionController.isLastAnswerCorrect()) {
                              return Icon(Icons.check,
                                  size: 56, color: Colors.green.shade600);
                            } else {
                              return Icon(Icons.close,
                                  size: 56, color: Colors.red.shade600);
                            }
                          } else {
                            return Container();
                          }
                        }),
                      ),
                      Container(
                          width: 256,
                          decoration: const BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 3, color: Colors.black),
                          )),
                          child: Center(
                            child: Obx(() => SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: AnswerTypingWidget(
                                      _questionController.userAnswer),
                                )),
                          )),
                    ],
                  ),
                  NumpadWidget(
                    typeNumber: typeNumber,
                    clearAnswer: clearAnswer,
                    answer: answer,
                  ),
                  optionalContinueWidget(),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 36, 24, 0),
                child: IconButton(
                    onPressed: changeQuestion,
                    icon: const Icon(
                      Icons.refresh,
                      size: 56,
                      color: Colors.purple,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
