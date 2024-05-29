import 'package:loggy/loggy.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math';

import 'package:sum_plus/ui/pages/content/quest_page.dart';
import 'package:sum_plus/ui/widgets/app_bar_widget.dart';
import 'package:sum_plus/ui/widgets/answer_item_widget.dart';

import 'package:sum_plus/ui/widgets/level_stars_widget.dart';

import 'package:sum_plus/ui/controller/question_controller.dart';

import 'package:sum_plus/domain/models/answer.dart';

class SessionSummaryPage extends StatefulWidget {
  const SessionSummaryPage({Key? key}) : super(key: key);

  @override
  SessionSummaryPageState createState() => SessionSummaryPageState();
}

class SessionSummaryPageState extends State<SessionSummaryPage>
    with WidgetsBindingObserver {
  final QuestionController _questionController = Get.find<QuestionController>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (willPop) {
        if (!willPop) return;
        _questionController.endSession();
      },
      child: Scaffold(
        appBar: AppBarWidget(
          text: 'Results',
          logoutButton: false,
          backButton: true,
        ),
        body: Container(
          padding: const EdgeInsets.fromLTRB(16, 48, 16, 36),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Column(
                      children: [
                        LevelStarsWidget(
                          level: min(_questionController.level,
                              _questionController.maxLevel),
                          starSize: 56,
                        ),
                        const Text('New level!',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Itim')),
                        Text(
                            '${_questionController.session.numCorrectAnswers}/${_questionController.session.numAnswers} correct answers',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Itim')),
                        Text(
                            'Total time: ${Answer.formatTime(_questionController.session.totalSeconds)}',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Itim')),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Column(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Answers',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Itim')),
                        SizedBox(
                          height: 360,
                          child: _questionController.session.answers.isNotEmpty
                              ? ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return const SizedBox(height: 6);
                                  },
                                  // scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: _questionController
                                      .session.answers.length,
                                  itemBuilder: (context, i) =>
                                      (AnswerItemWidget(
                                    answer:
                                        _questionController.session.answers[i],
                                    numAnswer: i + 1,
                                  )),
                                )
                              : Container(),
                        )
                      ],
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade200,
                          foregroundColor: Colors.black87),
                      onPressed: () {
                        _questionController.endSession();
                        Get.back();
                      },
                      child: const Text('Back to menu',
                          style: TextStyle(fontSize: 20, fontFamily: 'Itim')),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _questionController.endSession();
                        Get.off(() => const QuestPage(
                              key: Key('QuestPage'),
                            ));
                      },
                      child: const Text('Try again',
                          style: TextStyle(fontSize: 20, fontFamily: 'Itim')),
                    ),
                  ],
                )
              ]),
        ),
      ),
    );
  }
}
