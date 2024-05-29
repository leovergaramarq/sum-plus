import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:sum_plus/my_app.dart';

import 'package:sum_plus/ui/controller/auth_controller.dart';
import 'package:sum_plus/ui/controller/question_controller.dart';
import 'package:sum_plus/ui/controller/session_controller.dart';
import 'package:sum_plus/ui/controller/user_controller.dart';

import 'package:sum_plus/domain/repositories/auth_repository.dart';
import 'package:sum_plus/domain/repositories/session_repository.dart';
import 'package:sum_plus/domain/repositories/user_repository.dart';

import 'package:sum_plus/data/repositories/auth_authserver_repository.dart';
import 'package:sum_plus/data/repositories/session_retool_repository.dart';
import 'package:sum_plus/data/repositories/user_retool_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Get.put<AuthRepository>(AuthAuthserverRepository());
  Get.put<SessionRepository>(SessionRetoolRepository());
  Get.put<UserRepository>(UserRetoolRepository());

  Get.put<AuthController>(AuthController());
  Get.put<SessionController>(SessionController());
  Get.put<UserController>(UserController());
  Get.put<QuestionController>(QuestionController());

  runApp(const MyApp());
}
