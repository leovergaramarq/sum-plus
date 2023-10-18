import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/level_stars_widget.dart';
import 'package:get/get.dart';

void main() {
  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });
  testWidgets('LevelStarsWidget should these stars it is called',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LevelStarsWidget(level: 3),
      ),
    );
    expect(find.byType(Icon), findsNWidgets(3));
  });
}
