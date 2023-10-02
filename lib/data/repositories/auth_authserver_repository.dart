import 'package:uninorte_mobile_class_project/domain/repositories/auth_repository.dart';
import 'package:uninorte_mobile_class_project/data/datasources/remote/auth_datasource.dart';

class AuthAuthserverRepository implements AuthRepository {
  final AuthDatasource _authDatasource = AuthDatasource();
  String token = "";
  // the base url of the API should end without the /
  final String _baseUrl =
      "http://ip172-18-0-15-ckd3msufml8g00fmk3m0-8000.direct.labs.play-with-docker.com";

  Future<String> login(String email, String password) async {
    String token = await _authDatasource.login(_baseUrl, email, password);
    this.token = token;
    return token;
  }

  Future<void> signUp(String email, String password) async =>
      await _authDatasource.signUp(_baseUrl, email, password);

  Future<bool> logOut() async => await _authDatasource.logOut();
}