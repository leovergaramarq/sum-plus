import 'package:flutter/material.dart';

class AnswerTypingWidget extends StatelessWidget {
  const AnswerTypingWidget(this.input, {super.key});

  final int input;

  @override
  Widget build(BuildContext context) {
    return Text(
      input.toString(),
      style: const TextStyle(
        fontSize: 56,
        color: Colors.black,
      ),
    );
  }
}
