import 'package:flutter/material.dart';
import 'package:sum_plus/domain/models/answer.dart';

class AnswerItemWidget extends StatelessWidget {
  const AnswerItemWidget(
      {required this.answer, required this.numAnswer, Key? key})
      : super(key: key);

  final Answer answer;
  final int numAnswer;

  Widget answerMainInfoWidget() {
    List<Widget> children = [
      Text(
        'Question: ${answer.question.toString()}',
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Itim'),
      ),
      const SizedBox(
        height: 8,
      ),
      Row(
        children: [
          Text(
            'Your answer: ${answer.userAnswer}',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Itim'),
          ),
          answer.isCorrect
              ? Icon(Icons.check, size: 32, color: Colors.green.shade600)
              : Icon(Icons.close, size: 32, color: Colors.red.shade600),
        ],
      ),
    ];
    if (!answer.isCorrect) {
      children.addAll([
        const SizedBox(
          height: 8,
        ),
        Text(
          'Correct answer: ${answer.question.getAnswer()}',
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Itim'),
        )
      ]);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/img/random_art.png', // Reemplaza con la ruta de tu imagen de fondo
              ),
              Container(
                  padding: const EdgeInsets.fromLTRB(12, 16, 0, 16),
                  child: answerMainInfoWidget())
            ],
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 8, 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '#$numAnswer',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w400),
                ),
                const SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.av_timer,
                      size: 24,
                      color: const Color(0x003c3c3c).withOpacity(1),
                    ),
                    Text(
                      Answer.formatTime(answer.seconds),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
