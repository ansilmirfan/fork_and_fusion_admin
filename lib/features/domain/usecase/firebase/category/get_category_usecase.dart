import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class GetCategoryUsecase {
  CategoryRepo repo;
  GetCategoryUsecase(this.repo);
  Future<List<CategoryEntity>> call() async {
    return await repo.getAllCategory();
  }
}
