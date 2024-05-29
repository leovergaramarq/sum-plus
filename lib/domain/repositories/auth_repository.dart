abstract class AuthRepository {
  Future<String> login(String email, String password);

  Future<void> signUp(String email, String password);

  Future<bool> logOut();

  Future<bool> isLoggedIn();
}
