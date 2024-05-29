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
    Color(0xC68663).withOpacity(1),
    Color(0x858B94).withOpacity(1),
    Color(0xFFDC64).withOpacity(1),
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
    // print('level $level');
    // print('getNumStars ${getNumStars()}');
    // print('getColorIndex ${getColorIndex()}');
    int numStars = getNumStars();

    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
            numStars,
            (index) => Padding(
                  padding:
                      EdgeInsets.only(left: index != numStars - 1 ? gap : 0),
                  // child: Image.asset(
                  //   'assets/img/star_level.png', // Ruta de tu imagen personalizada
                  //   width: starSize, // Establece el ancho de la imagen
                  //   height: starSize, // Establece la altura de la imagen
                  // ),
                  child: Icon(
                    Icons.star,
                    color: colors[getColorIndex()],
                    // color: Color(0x9C5B38).withOpacity(1),
                    size: starSize,
                  ),
                )));
  }
}
