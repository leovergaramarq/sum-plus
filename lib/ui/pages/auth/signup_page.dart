import 'package:loggy/loggy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:sum_plus/ui/pages/content/home_page.dart';
import 'package:sum_plus/ui/pages/auth/login_page.dart';
import 'package:sum_plus/ui/pages/auth/first_page.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';

import 'package:sum_plus/domain/models/user.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _schoolController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();

  final AuthController _authController = Get.find<AuthController>();
  final UserController _userController = Get.find<UserController>();
  final SessionController _sessionController = Get.find<SessionController>();
  final QuestionController _questionController = Get.find<QuestionController>();

  @override
  void initState() {
    super.initState();
    if (_authController.isLoggedIn || _authController.isGuest) {
      _authController.logOut().catchError((err) {
        logError(err);
      });
    }
    if (_userController.isUserFetched) {
      _userController.resetUser().catchError((err) {
        logError(err);
      });
    }
    if (_sessionController.areSessionsFetched) {
      _sessionController.resetSessions().catchError((err) {
        logError(err);
      });
    }
    _questionController.resetLevel();
  }

  void onSubmit() async {
    BuildContext context;
    try {
      context = _scaffoldKey.currentContext!;
    } catch (err) {
      logError(err);
      return;
    }

    // this line dismiss the keyboard by taking away the focus of the TextFormField and giving it to an unused
    FocusScope.of(context).requestFocus(FocusNode());
    final FormState? form = _formKey.currentState;

    // Save form
    try {
      form!.save();
    } catch (err) {
      logError(err);
      return;
    }

    // Validate form
    if (!form.validate()) return;

    String email = _emailController.text.trim();

    // New user
    User newUser = User(
        id: null,
        birthDate: _dateController.text,
        degree: _degreeController.text.trim(),
        school: _schoolController.text.trim(),
        email: email,
        firstName: '',
        lastName: '');

    // Check if user already exists in Web Service. If so, update it. If not, create it.
    bool userExists;
    try {
      await _userController.getUser(email);
      userExists = true;
    } catch (err) {
      userExists = false;
    }

    logInfo(userExists
        ? 'User exists in Web Service: ${_userController.user}'
        : 'User doesn\'t exist in Web Service');

    if (userExists) {
      newUser.id = _userController.user.id;

      // Update existing user in Web Service
      bool userUpdated;
      try {
        await _userController.updatePartialUser(
            birthDate: newUser.birthDate,
            degree: newUser.degree,
            school: newUser.school,
            firstName: newUser.firstName,
            lastName: newUser.lastName);
        userUpdated = true;
      } catch (err) {
        logError(err);
        userUpdated = false;
      }

      if (!userUpdated) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User update failed in Web Service'),
            duration: Duration(seconds: 3),
          ));
        }
        return;
      }
    } else {
      // Create new user in Web Service
      bool userCreated;
      try {
        await _userController.addUser(newUser);
        userCreated = true;
      } catch (err) {
        logError(err);
        userCreated = false;
      }

      if (!userCreated) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('User creation failed in Web Service'),
            duration: Duration(seconds: 3),
          ));
        }
        return;
      }
    }

    // Sign up in Auth Service
    bool signedUp;
    try {
      await _authController.signUp(email, _passwordController.text);
      signedUp = true;
    } catch (err) {
      logError(err);
      signedUp = false;
    }
    logInfo(signedUp ? 'Signed up' : 'Not signed up');

    if (signedUp) {
      if (_authController.isLoggedIn) {
        if (userExists) {
          try {
            _questionController.setLevel(_userController.user.level!);
          } catch (err) {
            logInfo('Couldn\'t set level ${_userController.user.level}');
            logError(err);
          }
        }

        Get.offAll(() => HomePage(
              key: const Key('HomePage'),
            ));
      } else {
        Get.off(() => const LoginPage(
              key: Key('LoginPage'),
            ));
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registration failed'),
          duration: Duration(seconds: 3),
        ));
      }
    }
  }

  void onGoBack() {
    Get.offAll(() => const FirstPage(
          key: Key('FirstPage'),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(children: [
            // Capa 1: Imagen de fondo
            Image.asset(
              'assets/Seconbg.png', // Reemplaza con la ruta de tu imagen de fondo
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),

            // Capa 2: Contenido en el centro
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 25.0, 20.0, 12.0),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Sum+',
                        style: TextStyle(
                          fontFamily: 'Itim',
                          fontSize: 64,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        "Please fill the form to create an account",
                        style: TextStyle(fontSize: 17),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        key: const Key('TextFormFieldSignUpEmail'),
                        controller: _emailController,
                        decoration: const InputDecoration(labelText: 'Email'),
                        // onChanged: (value) {
                        //   _emailController.text = value.trim();
                        //   _emailController.selection = TextSelection.fromPosition(
                        //       TextPosition(offset: _emailController.text.length));
                        // },
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
                        key: const Key('TextFormFieldSignUpPassword'),
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
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TextFormField(
                          key: const Key('TextFormFieldSignUpBirthdate'),
                          controller: _dateController,
                          decoration: const InputDecoration(
                            icon: Icon(Icons.calendar_today_rounded),
                            labelText: "Birthdate",
                          ),
                          onTap: () async {
                            DateTime? pickeddate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2050));
                            if (pickeddate != null) {
                              _dateController.text =
                                  DateFormat('yyyy-MM-dd').format(pickeddate);
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Enter birthdate";
                            }
                            DateTime date;
                            try {
                              date = DateTime.parse(value);
                            } catch (err) {
                              return "Enter birthdate in valid format";
                            }
                            if (date.isAfter(DateTime.now())) {
                              return "Enter valid birthdate";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        key: const Key('TextFormFieldSignUpSchool'),
                        controller: _schoolController,
                        decoration: const InputDecoration(labelText: "School"),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter school";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        key: const Key('TextFormFieldSignUpGrade'),
                        controller: _degreeController,
                        decoration: const InputDecoration(labelText: "Grade"),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter grade";
                          } else if (int.parse(value) < 1 ||
                              int.parse(value) > 11) {
                            return "Grade should be between 1 and 11";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      OutlinedButton(
                          key: const Key('ButtonSignUpSubmit'),
                          onPressed: onSubmit,
                          style: OutlinedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 166, 137, 204),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            minimumSize: const Size(100, 40),
                          ),
                          child: const Text("Submit",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Inter',
                                fontSize: 15,
                              ))),
                    ],
                  )),
                ),
              ),
            ),
            IconButton(
                key: const Key('ButtonSignUpGoBack'),
                onPressed: onGoBack,
                icon: const Icon(Icons.arrow_back))
          ]),
        ));
  }
}
