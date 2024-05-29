import 'dart:math';
// import 'package:get/get.dart';

import 'package:sum_plus/domain/models/question.dart';
// import 'package:sum_plus/domain/repositories/question_repository.dart';

import 'package:sum_plus/domain/models/session.dart';
import 'package:sum_plus/domain/models/answer.dart';

class QuestionUseCase {
  // static fields
  final int questionsPerSession = 6;
  final int maxLevel = _levelsConfig.length;

  Question getQuestion(int level) {
    if (level < 1 || level > maxLevel) {
      level = _boundLevel(level);
    }
    _LevelConfig levelConfig = _levelsConfig[level - 1];

    Random random = Random();

    OperandsDigits operandsDigits = levelConfig
        .operandsDigits[random.nextInt(levelConfig.operandsDigits.length)];

    int digitsNum1 = operandsDigits != OperandsDigits.twoTwo ? 1 : 2;
    int digitsNum2 = operandsDigits != OperandsDigits.oneOne ? 2 : 1;

    int num1 = genNumberWithDigits(digitsNum1);
    int num2 = genNumberWithDigits(digitsNum2);

    Operation op =
        levelConfig.operations[random.nextInt(levelConfig.operations.length)];
    if ((op == Operation.div || op == Operation.sub) && num1 < num2) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }
    return Question(num1, op, num2, level);
  }

  bool isAnswerCorrect(Question question, int answer) =>
      answer == question.getAnswer();

  int concatTypedNumber(currAnswer, typedNumber) =>
      int.parse(currAnswer.toString() + typedNumber.toString());

  bool areAllQuestionsAnswered(List<Answer> answers) =>
      answers.length >= questionsPerSession;

  int _boundLevel(int newLevel) {
    return min(max(newLevel, 1), maxLevel);
  }

  int getNewLevel(Session session, int level) {
    if (level < 1 || level > maxLevel) {
      return _boundLevel(level);
    }

    _LevelConfig levelConfig = _levelsConfig[level - 1];
    List<Answer> answers = session.answers;

    if (answers.length >= levelConfig.numCorrectToLevelUp) {
      List<Answer> lastAnswers = answers
          .getRange(
              answers.length - levelConfig.numCorrectToLevelUp, answers.length)
          .toList();

      if (!lastAnswers.every(
          (answer) => answer.question.level == lastAnswers[0].question.level)) {
        return _boundLevel(level);
      }

      int numCorrect = 0;
      int numCorrectInTime = 0;

      for (Answer answer in lastAnswers) {
        if (answer.isCorrect) {
          numCorrect++;
          if (answer.seconds <= levelConfig.secondsExpected) {
            numCorrectInTime++;
          }
        }
      }

      if (numCorrect >= levelConfig.numCorrectToLevelUp) {
        if (numCorrectInTime >= numCorrect / 2) {
          return _boundLevel(level + 1);
        } else {
          return _boundLevel(level);
        }
      } else if (lastAnswers.length - numCorrect >=
          levelConfig.numWrongToLevelDown) {
        return _boundLevel(level - 1);
      } else {
        return _boundLevel(level);
      }
    } else {
      return _boundLevel(level);
    }
  }

  int genNumberWithDigits(int numDigits) {
    Random random = Random();

    int minRange = pow(10, numDigits - 1).toInt();
    int maxRange = pow(10, numDigits).toInt() - 1;

    return minRange + random.nextInt(maxRange - minRange);
  }
}

const List<_LevelConfig> _levelsConfig = [
  // additions and subtractions
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: -1,
    operations: [Operation.add],
    operandsDigits: [OperandsDigits.oneOne],
    secondsExpected: 6,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.add],
    operandsDigits: [OperandsDigits.oneTwo],
    secondsExpected: 10,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.sub],
    operandsDigits: [OperandsDigits.oneOne],
    secondsExpected: 8,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.sub],
    operandsDigits: [OperandsDigits.oneTwo],
    secondsExpected: 12,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.add],
    operandsDigits: [OperandsDigits.twoTwo],
    secondsExpected: 15,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.sub],
    operandsDigits: [OperandsDigits.twoTwo],
    secondsExpected: 20,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 3,
    numWrongToLevelDown: 3,
    operations: [Operation.add, Operation.sub],
    operandsDigits: [OperandsDigits.oneTwo, OperandsDigits.twoTwo],
    secondsExpected: 20,
  ),
  // multiplications and divisions
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.mul],
    operandsDigits: [OperandsDigits.oneOne],
    secondsExpected: 10,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.mul],
    operandsDigits: [OperandsDigits.oneTwo],
    secondsExpected: 15,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.div],
    operandsDigits: [OperandsDigits.oneOne],
    secondsExpected: 12,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.div],
    operandsDigits: [OperandsDigits.oneTwo],
    secondsExpected: 20,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.mul],
    operandsDigits: [OperandsDigits.twoTwo],
    secondsExpected: 25,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 2,
    numWrongToLevelDown: 2,
    operations: [Operation.div],
    operandsDigits: [OperandsDigits.twoTwo],
    secondsExpected: 30,
  ),
  const _LevelConfig(
    numCorrectToLevelUp: 3,
    numWrongToLevelDown: 3,
    operations: [Operation.mul, Operation.div],
    operandsDigits: [OperandsDigits.oneTwo, OperandsDigits.twoTwo],
    secondsExpected: 25,
  ),
  // all operations
  const _LevelConfig(
    numCorrectToLevelUp: -1,
    numWrongToLevelDown: 3,
    operations: [Operation.add, Operation.sub, Operation.mul, Operation.div],
    operandsDigits: [OperandsDigits.twoTwo],
    secondsExpected: 30,
  ),
];

class _LevelConfig {
  const _LevelConfig({
    required this.numCorrectToLevelUp,
    required this.numWrongToLevelDown,
    required this.operations,
    required this.operandsDigits,
    required this.secondsExpected,
  });

  final int numCorrectToLevelUp;
  final int numWrongToLevelDown;
  final List<Operation> operations;
  final List<OperandsDigits> operandsDigits;
  final int secondsExpected;
}

enum OperandsDigits { oneOne, oneTwo, twoTwo }
