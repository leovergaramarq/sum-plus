// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/question_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/session_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/login_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/signup_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/first_page.dart';
import 'package:uninorte_mobile_class_project/main.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/home_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/profile_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/history_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/profile_page.dart';
import 'package:uninorte_mobile_class_project/ui/pages/content/quest_page.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/app_bar_widget.dart';
import 'package:uninorte_mobile_class_project/ui/widgets/bottom_nav_bar_widget.dart';

void main() {
  //Test de la primera pagina

  setUp(() {
    Get.put(AuthController());
    Get.put(UserController());
    Get.put(SessionController());
    Get.put(QuestionController());
  });
  testWidgets('First Page to Login Page', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: FirstPage(key: Key('FirstPage'))),
    );

    expect(find.byKey(const Key('FirstPage')), findsOneWidget);

    await tester.tap(find.byKey(const Key('LoginButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('LoginPage')), findsOneWidget);
  });

  //Test de autenticación de usuario
  testWidgets('Widget login validación @ email', (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: LoginPage(key: Key('LoginPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'sinarroba.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123456');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(find.text('Enter valid email address'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123456');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(find.text('Enter valid email address'), findsNothing);
  });

  testWidgets('Widget login validación número de caracteres password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: LoginPage(key: Key('LoginPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(find.text('Password should have at least 6 characters'),
        findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123456');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(
        find.text('Password should have at least 6 characters'), findsNothing);
  });

  testWidgets('Widget login validación campo vacio password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: LoginPage(key: Key('LoginPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(find.text('Enter password'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldLoginPassword')), '123456');
    await tester.tap(find.byKey(const Key('ButtonLoginSubmit')));
    await tester.pump();
    expect(find.text('Enter password'), findsNothing);
  });

  testWidgets('LoginPage to SingUp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const GetMaterialApp(home: LoginPage(key: Key('LoginPage'))),
    );
    await tester.tap(find.byKey(const Key('ButtonLoginCreateAccount')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('SignUpPage')), findsOneWidget);
  });

  testWidgets('Widget signUp validación @ email', (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'sinarroba.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pumpAndSettle();
    expect(find.text('Enter valid email address'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pumpAndSettle();
    expect(find.text('Enter valid email address'), findsNothing);
  });

  testWidgets('Widget signUp validación número de caracteres password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Password should have at least 6 characters'),
        findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(
        find.text('Password should have at least 6 characters'), findsNothing);
  });

  testWidgets('Widget signUp validación campo vacio password',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter password'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter password'), findsNothing);
  });

  testWidgets('Widget signUp validación con fecha vacia',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter birthdate'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter birthdate'), findsNothing);
  });

  testWidgets('Widget signUp validación con escuela vacia',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), '');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter school'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter school'), findsNothing);
  });

  testWidgets('Widget signUp validación con grado vacio',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter grade'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Enter grade'), findsNothing);
  });

  testWidgets('Widget signUp validación con grado no valido',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '0');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Grade should be between 1 and 11'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pump();
    expect(find.text('Grade should be between 1 and 11'), findsNothing);
  });

  testWidgets('Widget SingUp exitosa', (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: SignUpPage(key: Key('SignUpPage'))));
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpEmail')), 'a@a.com');

    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpPassword')), '123456');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpBirthdate')), '2021-10-10');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpSchool')), 'Uninorte');
    await tester.enterText(
        find.byKey(const Key('TextFormFieldSignUpGrade')), '10');
    await tester.tap(find.byKey(const Key('ButtonSignUpSubmit')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('LoginPage')), findsNothing);
  });

  //Test de Home

  testWidgets('HomePage to questionPage', (WidgetTester tester) async {
    await tester
        .pumpWidget(GetMaterialApp(home: HomePage(key: const Key('HomePage'))));
    await tester.tap(find.byKey(const Key('StartButton')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('QuestPage')), findsOneWidget);
  });

  //Test Perfil

  testWidgets('Info en perfil', (WidgetTester tester) async {
    await tester.pumpWidget(
        GetMaterialApp(home: ProfilePage(key: const Key('ProfilePage'))));
    expect(find.text('Personal Info'), findsOneWidget);
  });

  //Test Quest Page

  testWidgets('Salida del Question en medio de la sesion',
      (WidgetTester tester) async {
    await tester.pumpWidget(
        const GetMaterialApp(home: QuestPage(key: Key('QuestPage'))));
    expect(find.text('Level'), findsOneWidget);
    expect(find.text('Exercise'), findsOneWidget);
  });

  //History

  testWidgets('History', (WidgetTester tester) async {
    await tester.pumpWidget(
        GetMaterialApp(home: HistoryPage(key: const Key('HistoryPage'))));
    expect(find.byKey(const Key('HistoryPage')), findsOneWidget);
  });

  //test bottom nav bar

  testWidgets('Navegación del Widget Home', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: BottomNavBarWidget(
        key: const Key('BottomNavBar'),
        section: BottomNavBarWidgetSection.home,
      ),
    ));
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.home), findsOneWidget);
  });
  testWidgets('Navegación del Widget Perfil', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: BottomNavBarWidget(
        key: const Key('BottomNavBar'),
        section: BottomNavBarWidgetSection.profile,
      ),
    ));
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.person), findsOneWidget);
  });
  testWidgets('Navegación del Widget Historial', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: BottomNavBarWidget(
        key: const Key('BottomNavBar'),
        section: BottomNavBarWidgetSection.history,
      ),
    ));
    await tester.tap(find.byIcon(Icons.history));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.history), findsOneWidget);
  });

  //AppBarWidget

  testWidgets('AppBarWidget', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: AppBarWidget(
        key: const Key('AppBarWidget'),
        text: 'Home',
        backButton: false,
        logoutButton: false,
      ),
    ));
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('AppBarLogOut', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      home: AppBarWidget(
        key: const Key('AppBarWidget'),
        text: 'Home',
        backButton: false,
        logoutButton: false,
      ),
    ));
    expect(find.byIcon(Icons.logout), findsNothing);
  });
}
