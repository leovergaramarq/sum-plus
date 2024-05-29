import 'package:flutter/material.dart';

import 'package:sum_plus/domain/models/question.dart';

class QuestionWidget extends StatelessWidget {
  const QuestionWidget({super.key, required this.question});

  final Question question;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(
        question.num1.toString(),
        style: const TextStyle(fontSize: 56),
      ),
      const SizedBox(width: 16),
      Text(
        question.opString,
        style: const TextStyle(fontSize: 56, color: Colors.purple),
      ),
      const SizedBox(width: 16),
      Text(
        question.num2.toString(),
        style: const TextStyle(fontSize: 56),
      )
    ]));
  }
}
