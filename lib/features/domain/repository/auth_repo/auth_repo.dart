abstract class AuthRepo {
  Future<void> createAdmin();
  Future<bool> authenticateAdmin(String name, String password);
}
