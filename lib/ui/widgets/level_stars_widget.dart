import 'package:flutter/material.dart';
import 'dart:math';
import 'package:get/get.dart';

import 'package:sum_plus/ui/controller/question_controller.dart';

class LevelStarsWidget extends StatelessWidget {
  LevelStarsWidget(
      {Key? key, required this.level, this.starSize = 28, this.gap = 0})
      : super(key: key);

  final int level;
  final int maxStars = 5;
  final double starSize;
  final double gap;
  final QuestionController _questionController = Get.find<QuestionController>();

  static final List<Color> colors = [
    const Color(0x00c68663).withOpacity(1),
    const Color(0x00858b94).withOpacity(1),
    const Color(0x00ffdc64).withOpacity(1),
  ];

  int getColorIndex() {
    return min((level - 1) ~/ maxStars, colors.length - 1);
  }

  int getNumStars() {
    return ((level - 1) % maxStars + 1) +
        (level > _questionController.maxLevel
            ? level - _questionController.maxLevel
            : 0);
  }

  @override
  Widget build(BuildContext context) {
    int numStars = getNumStars();

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            numStars,
            (index) => Padding(
                  padding:
                      EdgeInsets.only(left: index != numStars - 1 ? gap : 0),
                  child: Icon(
                    Icons.star,
                    color: colors[getColorIndex()],
                    size: starSize,
                  ),
                )));
  }
}
