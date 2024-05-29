import 'dart:async';

import 'package:get/get.dart';
import 'package:loggy/loggy.dart';

import 'package:sum_plus/domain/use_case/question_use_case.dart';

import 'package:sum_plus/domain/models/question.dart';
import 'package:sum_plus/domain/models/session.dart';
import 'package:sum_plus/domain/models/answer.dart';

class QuestionController extends GetxController {
  // states
  final QuestionUseCase _questionUseCase = QuestionUseCase();
  final RxInt _level = RxInt(1);
  final RxInt _userAnswer = RxInt(0);
  final Rx<Question> _question = Rx<Question>(Question.defaultQuestion());
  final RxBool _isQuestionReady = RxBool(false);
  final RxBool _didAnswer = RxBool(false);
  final Rx<Session> _session = Rx<Session>(Session.defaultSession());
  final RxBool _isSessionActive = RxBool(false);
  final _answerSeconds = RxInt(0);

  // Getters
  int get level => _level.value;
  int get userAnswer => _userAnswer.value;
  Question get question => _question.value;
  bool get isQuestionReady => _isQuestionReady.value;
  bool get didAnswer => _didAnswer.value;
  Session get session => _session.value;
  bool get isSessionActive => _isSessionActive.value;
  int get answerSeconds => _answerSeconds.value;
  StreamSubscription<int> Function(void Function(int),
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) get listenLevel => _level.listen;
  int get maxLevel => _questionUseCase.maxLevel;
  int get questionsPerSession => _questionUseCase.questionsPerSession;

  void startSession(String userEmail) {
    if (isSessionActive) {
      logInfo('session is already active');
      return;
    }

    if (userEmail.isEmpty) {
      logInfo('userEmail is empty');
    }

    logInfo('Starting session');
    _session.value = Session.defaultSession();
    _session.value.userEmail = userEmail;
    _isSessionActive.value = true;
  }

  void endSession() {
    if (!isSessionActive) {
      logInfo('session is not active');
      return;
    }

    resetStates();
  }

  void cancelSesion() {
    if (!isSessionActive) {
      logInfo('session is not active');
      return;
    }

    resetStates();
  }

  void wrapSessionUp() {
    _session.value.wrapUp(level);
  }

  Question? getQuestion() {
    if (!isSessionActive) {
      logInfo('session is not active');
      return null;
    }

    if (isQuestionReady) _isQuestionReady.value = false;

    Question question = _questionUseCase.getQuestion(level);
    _question.value = question;
    _isQuestionReady.value = true;

    return question;
  }

  bool nextQuestion() {
    if (!isSessionActive) return false;

    if (_questionUseCase.areAllQuestionsAnswered(session.answers)) {
      _isQuestionReady.value = false;
      return false;
    } else {
      getQuestion();

      // if (!isQuestionReady) _isQuestionReady.value = true;
      if (didAnswer) _didAnswer.value = false;
      return true;
    }
  }

  void typeNumber(int typedNumber) {
    if (!isSessionActive || !isQuestionReady) {
      logInfo('session is not active or question is not ready');
      return;
    }

    _userAnswer.value =
        _questionUseCase.concatTypedNumber(userAnswer, typedNumber);
  }

  void clearAnswer() {
    if (!isSessionActive || !isQuestionReady) {
      logInfo('session is not active or question is not ready');
      return;
    }

    _userAnswer.value = 0;
  }

  Answer? answer(int seconds) {
    if (!isSessionActive || !isQuestionReady) {
      logInfo('session is not active or question is not ready');
      return null;
    }

    _didAnswer.value = true;

    Answer newAnswer = Answer(
        userAnswer: userAnswer,
        isCorrect: _questionUseCase.isAnswerCorrect(question, userAnswer),
        question: question,
        userEmail: session.userEmail,
        seconds: seconds);

    _session.value.answers.add(newAnswer);
    _session.refresh();

    _level.value = _questionUseCase.getNewLevel(session, level);

    return newAnswer;
  }

  bool isLastAnswerCorrect() {
    if (!isSessionActive || !isQuestionReady) {
      logInfo('session is not active or question is not ready');
      return false;
    }

    if (session.answers.isEmpty) return false;

    return session.answers.last.isCorrect;
  }

  void setAnswerSeconds(int answerSeconds) {
    if (!isSessionActive || !isQuestionReady) {
      logInfo('session is not active or question is not ready');
      return;
    }
    _answerSeconds.value = answerSeconds;
  }

  void setLevel(int level) {
    _level.value = level;
  }

  void resetLevel() {
    _level.value = 1;
  }

  void resetStates() {
    // _level.value = 1;
    _userAnswer.value = 0;
    _question.value = Question.defaultQuestion();
    _isQuestionReady.value = false;
    _didAnswer.value = false;
    _session.value = Session.defaultSession();
    _isSessionActive.value = false;
    _answerSeconds.value = 0;
  }
}
