import 'package:sum_plus/domain/models/answer.dart';

class Session {
  Session({
    this.id,
    required this.answers,
    required this.userEmail,
    required this.totalSeconds,
    required this.numCorrectAnswers,
    required this.numAnswers,
    required this.avgLevel,
    required this.dateStart,
  });

  Session.defaultSession()
      : id = null,
        answers = [],
        userEmail = '',
        totalSeconds = 0,
        numCorrectAnswers = 0,
        numAnswers = 0,
        avgLevel = 0,
        dateStart = DateTime.now().toString();

  final int? id;
  final List<Answer> answers;
  String userEmail;
  int totalSeconds;
  int numCorrectAnswers;
  int numAnswers;
  int avgLevel;
  final String dateStart;

  void wrapUp(int? lastLevel) {
    numAnswers = answers.length;
    numCorrectAnswers = answers.where((answer) => answer.isCorrect).length;
    totalSeconds = answers
        .map((answer) => answer.seconds)
        .reduce((value, element) => value + element);

    if (lastLevel == null) {
      avgLevel = answers
              .map((answer) => answer.question.level)
              .reduce((value, element) => value + element) ~/
          answers.length;
    } else {
      for (int i = 1; i < answers.length; i++) {
        avgLevel += answers[i].question.level;
      }
      avgLevel += lastLevel;
      avgLevel ~/= answers.length;
    }
  }

  factory Session.fromJson(Map<String, dynamic> json) => Session(
        id: json['id'],
        // answers: json['answers'],
        answers: [],
        userEmail: json['userEmail'],
        totalSeconds: int.parse(json['totalSeconds'].toString()),
        numCorrectAnswers: int.parse(json['numCorrectAnswers'].toString()),
        numAnswers: int.parse(json['numAnswers'].toString()),
        avgLevel: int.parse(json['avgLevel'].toString()),
        dateStart: json['dateStart'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        // 'answers': answers,
        'userEmail': userEmail,
        'totalSeconds': totalSeconds,
        'numCorrectAnswers': numCorrectAnswers,
        'numAnswers': numAnswers,
        'avgLevel': avgLevel,
        'dateStart': dateStart,
      };
}
