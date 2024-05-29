import 'package:sum_plus/domain/repositories/auth_repository.dart';

import 'package:sum_plus/data/datasources/remote/auth_datasource.dart';
import 'package:sum_plus/data/datasources/local/auth_local_datasource.dart';

class AuthAuthserverRepository implements AuthRepository {
  final AuthDatasource _authDatasource = AuthDatasource();
  final AuthLocalDatasource _authLocalDatasource = AuthLocalDatasource();
  // the base url of the API should end without the /
  final String _baseUrl =
      "http://ip172-18-0-93-cpbb2i0l2o9000alsci0-8000.direct.labs.play-with-docker.com";

  @override
  Future<String> login(String email, String password) async {
    final String token = await _authDatasource.login(_baseUrl, email, password);
    if (!(await _authLocalDatasource.saveToken(token))) {
      return Future.error('Token couldn\'t be saved');
    }
    return token;
  }

  @override
  Future<void> signUp(String email, String password) async {
    await _authDatasource.signUp(_baseUrl, email, password);
    if (!(await _authLocalDatasource.saveToken('fakeToken'))) {
      return Future.error('Token couldn\'t be saved');
    }
  }

  @override
  Future<bool> logOut() async {
    if (await _authLocalDatasource.containsToken()) {
      return await _authLocalDatasource.removeToken();
    } else {
      return true;
    }
  }

  @override
  Future<bool> isLoggedIn() async {
    return await _authLocalDatasource.containsToken();
  }
}
