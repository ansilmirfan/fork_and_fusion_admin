import 'package:fork_and_fusion_admin/features/domain/repository/auth_repo/auth_repo.dart';

class CreateAdminUsecase {
  AuthRepo repo;
  CreateAdminUsecase(this.repo);
  Future<void> call() async {
    await repo.createAdmin();
  }
}
