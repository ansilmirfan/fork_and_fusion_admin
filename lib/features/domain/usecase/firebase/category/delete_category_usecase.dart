import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class DeleteCategoryUsecase {
  CategoryRepo repo;
  DeleteCategoryUsecase(this.repo);
  Future<bool> call(String id, String url) async {
    return await repo.deleteCategory(id, url);
  }
}
