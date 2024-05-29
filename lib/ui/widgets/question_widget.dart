import 'package:flutter/material.dart';

import 'package:sum_plus/domain/models/question.dart';

class QuestionWidget extends StatelessWidget {
  QuestionWidget({Key? key, required this.question});

  late Question question;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        question.num1.toString(),
        style: TextStyle(fontSize: 56),
      ),
      SizedBox(width: 16),
      Text(
        question.opString,
        style: TextStyle(fontSize: 56, color: Colors.purple),
      ),
      SizedBox(width: 16),
      Text(
        question.num2.toString(),
        style: TextStyle(fontSize: 56),
      )
    ]));
  }
}
