import 'package:fork_and_fusion_admin/features/data/data_source/secure_storage_data_source.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/auth_repo/auth_repo.dart';

class AuthRepository implements AuthRepo {
  SecureStorageDataSource dataSource = SecureStorageDataSource();

  @override
  Future<void> createAdmin() async {
    await dataSource.createAdmin();
  }

  @override
  Future<bool> authenticateAdmin(String name, String password) async {
    return await dataSource.authenticate(name, password);
  }
}
