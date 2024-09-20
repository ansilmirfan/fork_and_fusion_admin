import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class UpdateCategoryUsecase {
  CategoryRepo repo;
  UpdateCategoryUsecase(this.repo);
  Future<bool> call(String id, CategoryEntity newData) async {
    return await repo.updateCategory(id, newData);
  }
}
