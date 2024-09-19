

import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class CreateCategoryUsecase {
  CategoryRepo repo;
  CreateCategoryUsecase(this.repo);
  Future<void> call(CategoryEntity data) async {
  
    await repo.createCategory(data);
  }
}
