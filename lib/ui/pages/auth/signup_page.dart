import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:uninorte_mobile_class_project/ui/pages/content/home.dart';
import 'package:uninorte_mobile_class_project/ui/pages/auth/login_page.dart';

import 'package:uninorte_mobile_class_project/ui/controller/auth_controller.dart';
import 'package:uninorte_mobile_class_project/ui/controller/user_controller.dart';

import 'package:uninorte_mobile_class_project/domain/models/user.dart';

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

  @override
  void initState() {
    if (_authController.isLoggedIn || _authController.isGuest) {
      print('Logging out');
      _authController.logOut();
    }
    if (_userController.userFetched) {
      _userController.resetUser();
    }
    super.initState();
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
      print(form);
      form!.save();
    } catch (e) {
      print(e);
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
    } catch (e) {
      userExists = false;
    }
    print(userExists
        ? 'User exists in Web Service: ${_userController.user}'
        : 'User doesn\'t exist in Web Service');

    if (userExists) {
      newUser.id = _userController.user.id;

      // Update existing user in Web Service
      bool userUpdated;
      try {
        await _userController.updateUser(newUser);
        userUpdated = true;
      } catch (e) {
        print(e);
        userUpdated = false;
      }
      print(userUpdated ? 'User updated' : 'User not updated');

      if (!userUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User update failed in Web Service'),
        ));
        return;
      }
    } else {
      // Create new user in Web Service
      bool userCreated;
      try {
        await _userController.addUser(newUser);
        userCreated = true;
      } catch (e) {
        print(e);
        userCreated = false;
      }
      print(userCreated ? 'User created' : 'User not created');

      if (!userCreated) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('User creation failed in Web Service'),
        ));
        return;
      }
    }

    // Sign up in Auth Service
    bool signedUp;
    try {
      await _authController.signUp(email, _passwordController.text);
      signedUp = true;
    } catch (e) {
      print(e);
      signedUp = false;
    }
    print(signedUp ? 'Signed up' : 'Not signed up');

    if (signedUp) {
      if (_authController.isLoggedIn) {
        Get.off(HomePage(
          key: const Key('HomePage'),
        ));
      } else {
        Get.off(LoginPage(
          key: const Key('LoginPage'),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Registration failed'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        body: Stack(children: [
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
                      decoration: const InputDecoration(labelText: "Password"),
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
                          backgroundColor: Color.fromARGB(255, 166, 137, 204),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          minimumSize: Size(100, 40),
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
        ]));
  }
}
