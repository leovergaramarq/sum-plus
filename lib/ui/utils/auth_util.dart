import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';

class AuthUtil {
  final AuthController _authController = Get.find<AuthController>();

  Future<bool> validateLogout(BuildContext context) async =>
      _authController.isGuest ||
      (_authController.isLoggedIn && await confirmLogout(context));
  Future<bool> confirmLogout(BuildContext context) async =>
      await showDialog<bool>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: Text("Logout"),
                content: Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text("Continue"),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              )) ??
      false;
}
