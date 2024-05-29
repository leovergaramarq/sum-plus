import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/pages/auth/login_page.dart';
import 'package:sum_plus/ui/pages/auth/first_page.dart';
import 'package:sum_plus/ui/controller/auth_controller.dart';

void main() {
  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });

  testWidgets('FirstPage UI Test', (WidgetTester tester) async {
    // Build our FirstPage widget
    await tester.pumpWidget(
      const GetMaterialApp(
        home: FirstPage(),
      ),
    );
    // Verify that the 'Sum+' text is displayed
    expect(find.text('Sum+'), findsOneWidget);

    // Verify that the 'Let's start!' button is displayed
    expect(find.text("Let's start!"), findsOneWidget);

    // Tap the 'Let's start!' button
    await tester.tap(find.text("Let's start!"));
    await tester.pumpAndSettle();

    // Verify that the LoginPage is pushed onto the navigation stack
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
