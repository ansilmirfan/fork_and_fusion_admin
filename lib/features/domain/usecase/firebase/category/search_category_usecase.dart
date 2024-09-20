import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class SearchCategoryUsecase {
  CategoryRepo repo;
  SearchCategoryUsecase(this.repo);
  Future<List<CategoryEntity>> call(String querry) async {
    return await repo.search(querry);
  }
}
