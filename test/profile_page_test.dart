import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/app_bar_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/bottom_nav_bar_widget.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/profile_page.dart';

void main() {
  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });
  testWidgets('ProfilePage these things should be present',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ProfilePage(),
      ),
    );
    expect(find.byType(AppBarWidget), findsOneWidget);
    expect(find.byType(BottomNavBarWidget), findsOneWidget);
    expect(find.byType(CircleAvatar), findsOneWidget);
  });
}
