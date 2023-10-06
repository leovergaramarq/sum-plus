// import 'package:uninorte_mobile_class_project/data/datasources/remote/auth_datasource.dart';

abstract class AuthRepository {
  Future<String> login(String email, String password);

  Future<void> signUp(String email, String password);

  Future<bool> logOut();

  Future<bool> isLoggedIn();
}
