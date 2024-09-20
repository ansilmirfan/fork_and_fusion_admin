import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';

abstract class CategoryRepo {
  Future<void> createCategory(CategoryEntity data);
  Future<bool> updateCategory(String id, CategoryEntity newData);
  Future<bool> deleteCategory(String id, String url);
  Future<List<CategoryEntity>> getAllCategory();
  Future<List<CategoryEntity>> search(String querry);
}
