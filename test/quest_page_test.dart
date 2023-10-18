import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/quest_page.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/level_stars_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/question_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/answer_typing_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/numpad_widget.dart';

void main() {
  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });
  testWidgets('QuestPage should display UI elements',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: QuestPage(),
      ),
    );

    expect(find.byIcon(Icons.refresh), findsOneWidget);
    expect(find.byType(LevelStarsWidget), findsOneWidget);
    expect(find.byType(QuestionWidget), findsOneWidget);
    expect(find.byType(AnswerTypingWidget), findsOneWidget);
    expect(find.byType(NumpadWidget), findsOneWidget);
  });

  testWidgets('QuestPage should handle button interactions',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(
        home: QuestPage(),
      ),
    );
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();
    expect(find.byType(QuestionWidget), findsOneWidget);
  });
}
