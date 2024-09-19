import 'package:fork_and_fusion_admin/features/domain/repository/auth_repo/auth_repo.dart';

class AuthenticateAdminUsecase {
  AuthRepo repo;
  AuthenticateAdminUsecase(this.repo);
  Future<bool> call(String name, String password) async {
    return await repo.authenticateAdmin(name, password);
  }
}
