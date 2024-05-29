import 'package:sum_plus/domain/models/question.dart';
import 'package:sum_plus/ui/utils/helper_util.dart';

class Answer {
  Answer(
      {required this.question,
      required this.userAnswer,
      required this.seconds,
      required this.userEmail,
      required this.isCorrect});

  final Question question;
  final int userAnswer;
  final int seconds;
  final String userEmail;
  final bool isCorrect;

  static String formatTime(int seconds) {
    return HelperUtil.formatTime(seconds);
  }
}
