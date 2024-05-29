import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sum_plus/ui/pages/content/home_page.dart';
import 'package:sum_plus/ui/pages/auth/signup_page.dart';
import 'package:sum_plus/ui/pages/auth/first_page.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';

// import 'package:sum_plus/domain/models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();
  final QuestionController _questionController = Get.find<QuestionController>();

  @override
  void initState() {
    super.initState();
    if (_authController.isLoggedIn || _authController.isGuest) {
      _authController.logOut().catchError((e) => print(e));
    }
    if (_userController.isUserFetched) {
      _userController.resetUser().catchError((e) => print(e));
    }
    if (_sessionController.areSessionsFetched) {
      _sessionController.resetSessions().catchError((e) => print(e));
    }
    _questionController.resetLevel();
  }

  void onSubmit() async {
    BuildContext context;
    try {
      context = _scaffoldKey.currentContext!;
    } catch (e) {
      print(e);
      return;
    }
    // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
    FocusScope.of(context).requestFocus(FocusNode());
    final FormState? form = _formKey.currentState;

    // Save form
    try {
      form!.save();
    } catch (e) {
      print(e);
      return;
    }

    // Validate form
    if (!form.validate()) return;

    String email = _emailController.text.trim();

    // Validate if user exists in Web Service
    bool userExists;
    try {
      await _userController.getUser(email);
      userExists = true;
    } catch (e) {
      print(e);
      userExists = false;
    }
    print(userExists
        ? 'User exists in Web Service: ${_userController.user}'
        : 'User doesn\'t exist in Web Service');

    if (!userExists) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('User doesn\'t exist in Web Service'),
      ));
      return;
    }
    // Login in Auth Service
    bool loggedIn;
    try {
      await _authController.login(email, _passwordController.text);
      // print('Success');
      loggedIn = true;
    } catch (e) {
      print(e);
      loggedIn = false;
    }

    if (loggedIn) {
      if (_authController.isLoggedIn) {
        try {
          _questionController.setLevel(_userController.user.level!);
        } catch (err) {
          print('Couldn\'t set level ${_userController.user.level}');
          print(err);
        }

        Get.offAll(() => HomePage(
              key: const Key('HomePage'),
            ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Unexpected error'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Login failed'),
      ));
    }
  }

  void onGoBack() {
    Get.offAll(() => const FirstPage(
          key: Key('FirstPage'),
        ));
  }

  void onContinueAsGuest() {
    _authController.continueAsGuest();
    if (_authController.isGuest) {
      Get.off(() => HomePage(
            key: const Key('HomePage'),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xF2F2F2).withOpacity(1),
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              Image.asset(
                'assets/Seconbg.png', // Reemplaza con la ruta de tu imagen de fondo
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 12.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Sum+",
                          style: TextStyle(
                              fontFamily: 'Itim',
                              fontSize: 70,
                              color: Colors.black),
                        ),
                        const Text(
                          "Login with email",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: const Key('TextFormFieldLoginEmail'),
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter email";
                            } else if (!RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                            ).hasMatch(value.trim())) {
                              return "Enter valid email address";
                            } else {
                              return null;
                            }
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          key: const Key('TextFormFieldLoginPassword'),
                          controller: _passwordController,
                          decoration:
                              const InputDecoration(labelText: "Password"),
                          // keyboardType: TextInputType.number,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter password";
                            } else if (value.length < 6) {
                              return "Password should have at least 6 characters";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        OutlinedButton(
                            key: const Key('ButtonLoginSubmit'),
                            onPressed: onSubmit,
                            child: const Text(
                              "Submit",
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            )),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          height: 36,
                          child: TextButton(
                              key: const Key('ButtonLoginCreateAccount'),
                              onPressed: () => Get.offAll(
                                    () => const SignUpPage(
                                      key: Key('SignUpPage'),
                                    ),
                                  ),
                              child: const Text(
                                'Create account',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 36,
                          child: TextButton(
                              key: const Key('ButtonLoginContinueAsGuest'),
                              onPressed: onContinueAsGuest,
                              child: const Text(
                                'Continue as guest',
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 16),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              IconButton(
                  key: const Key('ButtonLoginGoBack'),
                  onPressed: onGoBack,
                  icon: const Icon(Icons.arrow_back))
            ],
          ),
        ));
  }
}
