import 'package:flutter/material.dart';
import 'package:sum_plus/domain/models/answer.dart';

class AnswerItemWidget extends StatelessWidget {
  AnswerItemWidget({required this.answer, required this.numAnswer});

  Answer answer;
  int numAnswer;

  Widget AnswerMainInfoWidget() {
    List<Widget> children = [
      Text(
        'Question: ${answer.question.toString()}',
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.w400, fontFamily: 'Itim'),
      ),
      SizedBox(
        height: 8,
      ),
      Row(
        children: [
          Text(
            'Your answer: ${answer.userAnswer}',
            style: TextStyle(
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
        SizedBox(
          height: 8,
        ),
        Text(
          'Correct answer: ${answer.question.getAnswer()}',
          style: TextStyle(
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
                  child: AnswerMainInfoWidget())
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
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),
                SizedBox(
                  height: 90,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      Icons.av_timer,
                      size: 24,
                      color: Color(0x3C3C3C).withOpacity(1),
                    ),
                    Text(
                      '${Answer.formatTime(answer.seconds)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
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
