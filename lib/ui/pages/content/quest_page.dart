import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:uninorte_mobile_class_project/ui/pages/content/session_summary_page.dart';

import 'package:uninorte_mobile_class_project/ui/widgets/answer_typing_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/app_bar_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/question_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/numpad_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/level_stars_widget.dart';

import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';

import 'package:uninorte_mobile_class_project/domain/models/answer.dart';

class QuestPage extends StatefulWidget {
  const QuestPage({Key? key}) : super(key: key);

  @override
  _QuestPageState createState() => _QuestPageState();
}

class _QuestPageState extends State<QuestPage> with WidgetsBindingObserver {
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
        print('Updating level from ${_userController.user.level} to $level');
        try {
          await _userController.updatePartialUser(level: level);
        } catch (e) {
          print(e);
        }
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    print('Disposing QuestPage');
    _answerTimer.cancel();
    if (_levelListener != null) {
      try {
        _levelListener!.cancel();
      } catch (e) {
        print(e);
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
      if (_authController.isLoggedIn) {
        _sessionController
            .addSession(_questionController.session)
            .catchError((e) => print(e));
      }
      Get.off(() => const SessionSummaryPage(
            key: Key('SessionSummaryPage'),
          ));
    }
  }

  void changeQuestion() {
    if (!_questionController.didAnswer) nextQuestion();
  }

  Widget OptionalContinueWidget() {
    return Obx(() {
      if (_questionController.didAnswer) {
        return Column(
          children: [
            SizedBox(
              height: 24,
            ),
            ElevatedButton(
              onPressed: nextQuestion,
              child: Text('Next', style: TextStyle(fontSize: 20)),
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

  Widget QuestionOrLoadWidget() {
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
    } catch (e) {
      print(e);
      return;
    }
    if (!_questionController.isQuestionReady) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please wait for the question to load'),
      ));
    } else if (_questionController.didAnswer) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('You already answered this question'),
      ));
    } else {
      _answerTimer.cancel();

      // print('seconds ${_questionController.answerSeconds}');

      Answer? newAnswer =
          _questionController.answer(_questionController.answerSeconds);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool leaveSession = await Future<bool>(() async =>
            await showDialog<bool>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text(
                          "If you go back, the current session will not be saved."),
                      actions: [
                        TextButton(
                          child: Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                        ),
                        TextButton(
                          child: Text("Continue"),
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                        ),
                      ],
                    )) ??
            false);
        if (leaveSession) _questionController.cancelSesion();
        return leaveSession;
      },
      child: Scaffold(
        backgroundColor: Color(0xF2F2F2).withOpacity(1),
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
                          Text(
                            'Level',
                            style: const TextStyle(
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
                  QuestionOrLoadWidget(),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 300, 0),
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
                          decoration: BoxDecoration(
                              border: Border(
                            bottom: BorderSide(width: 3, color: Colors.black),
                          )),
                          child: Center(
                            child: Obx(() => SingleChildScrollView(
                                  child: AnswerTypingWidget(
                                      _questionController.userAnswer),
                                  scrollDirection: Axis.horizontal,
                                )),
                          )),
                    ],
                  ),
                  // Stack(
                  //   alignment: Alignment.center,
                  //   children: [
                  //     Positioned(
                  //       left: 0,
                  //       child: Text('=asd'),
                  //     ),
                  //     Obx(() => AnswerWidget(_questionController.userAnswer)),
                  //     // Text(
                  //     //   '=',
                  //     //   style: TextStyle(fontSize: 56),
                  //     // ),
                  //   ],
                  // ),
                  NumpadWidget(
                    typeNumber: typeNumber,
                    clearAnswer: clearAnswer,
                    answer: answer,
                  ),
                  OptionalContinueWidget(),
                ],
              ),
            ),
            Align(
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
              alignment: Alignment.topRight,
            )
          ],
        ),
      ),
    );
  }
}
