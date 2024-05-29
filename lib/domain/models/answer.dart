import 'package:sum_plus/domain/models/question.dart';

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
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String formattedTime = '';

    if (hours > 0) {
      formattedTime += '$hours h, ';
    }

    if (minutes > 0 || hours > 0) {
      formattedTime += '$minutes m, ';
    }

    formattedTime += '$remainingSeconds s';

    return formattedTime;
  }
}
