// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get/get.dart';
// import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
// import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
// import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
// import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
// import 'package:uninorte_mobile_class_project/ui/pages/auth/login_page.dart';
// import 'package:uninorte_mobile_class_project/ui/pages/content/home_page.dart';

// void main() {
//   setUp(() {
//     Get.put(AuthController());
//     Get.put(UserController());
//     Get.put(SessionController());
//     Get.put(QuestionController());
//   });
//   testWidgets('LoginPage UI Test', (WidgetTester tester) async {
//     // Construir la página LoginPage
//     await tester.pumpWidget(
//       const GetMaterialApp(
//         home: LoginPage(),
//       ),
//     );

//     // Verificar que se muestre el texto "Sum+" en la pantalla
//     expect(find.text("Sum+"), findsOneWidget);

//     // Simular la entrada de texto en el campo de correo electrónico
//     await tester.enterText(
//         find.byKey(const Key('TextFormFieldLoginEmail')), 'test@example.com');

//     // Simular la entrada de texto en el campo de contraseña
//     await tester.enterText(
//         find.byKey(const Key('TextFormFieldLoginPassword')), 'password123');

//     // Toca el botón "Submit" para enviar el formulario
//     await tester.tap(find.byKey(const Key('ButtonLoginCreateAccount')));

//     // Espera a que la UI se actualice después de tocar el botón
//     await tester.pumpAndSettle();

//     // Verificar que se haya realizado la navegación a otra pantalla
//     expect(find.byKey(const Key('SignUpPage')), findsOneWidget);
//   });
// }
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:get/get.dart';
import 'package:uninorte_mobile_class_project/domain/models/session.dart';
import 'package:uninorte_mobile_class_project/domain/models/user.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/login_page.dart';
import 'package:uninorte_mobile_class_project/domain/use_case/auth_use_case.dart';

class MockAuthController extends GetxController
    with Mock
    implements AuthController {}

class MockUserController extends GetxController
    with Mock
    implements UserController {}

class MockSessionController extends GetxController
    with Mock
    implements SessionController {}

class MockQuestionController extends GetxController
    with Mock
    implements QuestionController {}

void main() {
  late AuthController authController;
  late UserController userController;
  late SessionController sessionController;
  late QuestionController questionController;

  setUp(() {
    authController = MockAuthController();
    Get.put<AuthController>(authController);
    userController = MockUserController();
    Get.put<UserController>(userController);
    sessionController = MockSessionController();
    Get.put<SessionController>(sessionController);
    questionController = MockQuestionController();
    Get.put<QuestionController>(questionController);
  });

  testWidgets('Login Error', (WidgetTester tester) async {
    when(() => authController.isLoggedIn).thenReturn(false);
    when(() => authController.isGuest).thenReturn(false);
    when(() => userController.isUserFetched).thenReturn(false);
    when(() => sessionController.areSessionsFetched).thenReturn(false);
    when(() => questionController.resetLevel()).thenReturn(null);
    // Construir la página LoginPage
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(key: Key('LoginPage')),
      ),
    );

    // Verificar que se muestre el texto "Sum+" en la pantalla
    expect(find.text("Sum+"), findsOneWidget);

    // Simular la entrada de texto en el campo de correo electrónico
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'test@example.com');

    // Simular la entrada de texto en el campo de contraseña
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'password123');

    when(() => userController.getUser(any())).thenThrow(Exception());
    // Toca el botón "Submit" para enviar el formulario
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));

    // Espera a que la UI se actualice después de tocar el botón
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('LoginPage')), findsOneWidget);
  });

  testWidgets('Login Successful', (WidgetTester tester) async {
    when(() => authController.isLoggedIn).thenReturn(false);
    when(() => authController.isGuest).thenReturn(false);
    when(() => userController.isUserFetched).thenReturn(false);
    when(() => sessionController.areSessionsFetched).thenReturn(false);
    when(() => questionController.resetLevel()).thenReturn(null);
    // Construir la página LoginPage
    await tester.pumpWidget(
      const GetMaterialApp(
        home: LoginPage(key: Key('LoginPage')),
      ),
    );

    // Verificar que se muestre el texto "Sum+" en la pantalla
    expect(find.text("Sum+"), findsOneWidget);

    // Simular la entrada de texto en el campo de correo electrónico
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'test@example.com');

    // Simular la entrada de texto en el campo de contraseña
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), 'password123');

    when(() => userController.getUser(any()))
        .thenAnswer((_) => Future.value(null));
    when(() => authController.login(any(), any()))
        .thenAnswer((_) => Future.value(null));
    when(() => authController.isLoggedIn).thenReturn(true);
    User user = User.defaultUser();
    user.level = 1;
    when(() => userController.user).thenReturn(user);
    // when(() => sessionController.areSessionsFetched).thenReturn(true);
    when(() => questionController.setLevel(any())).thenReturn(null);

    // Toca el botón "Submit" para enviar el formulario
    when(() => authController.isLoggedIn).thenReturn(true);
    when(() => sessionController.getSessionsFromUser(any(),
        limit: any(named: 'limit'))).thenAnswer((_) async => []);
    when(() => sessionController.sessions)
        .thenAnswer((_) => Rx<List<Session>>(<Session>[]).value);

    when(() => sessionController.areSessionsFetched)
        .thenAnswer((_) => true.obs.value);
    when(() => sessionController.numSummarizeSessions).thenReturn(5);
    RxInt level = 1.obs;
    when(() => questionController.level).thenAnswer((_) => level.value);
    when(() => questionController.maxLevel).thenReturn(8);
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));

    // Espera a que la UI se actualice después de tocar el botón
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('HomePage')), findsOneWidget);
  });
}
