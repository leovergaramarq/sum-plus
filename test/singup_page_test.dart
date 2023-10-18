import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/signup_page.dart';

void main() {
  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });
  testWidgets('SignUpPage UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const GetMaterialApp(
        home: SignUpPage(),
      ),
    );

    // Verify that text widgets are present
    expect(find.text('Sum+'), findsOneWidget);
    expect(
        find.text("Please fill the form to create an account"), findsOneWidget);

    // Fill in the text fields
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'test@example.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), 'password');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2000-01-01');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Test School');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '5');

    // Tap the submit button
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('HomePage')), findsNothing);
  });
}
