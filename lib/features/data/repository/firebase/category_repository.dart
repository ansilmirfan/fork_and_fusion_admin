import 'package:fork_and_fusion_admin/features/data/data_source/firebase/firebase_services.dart';
import 'package:fork_and_fusion_admin/features/data/model/category_model.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class CategoryRepository extends CategoryRepo {
  FirebaseServices dataSource = FirebaseServices();
  @override
  Future<void> createCategory(CategoryEntity data) async {
    var image = await dataSource.uploadImage(data.file!, 'category');
    data.image = image;
    await dataSource.create('category', CategoryModel.toMap(data));
  }

  @override
  Future<bool> updateCategory(String id, CategoryEntity newData) {
    // TODO: implement updateCategory
    throw UnimplementedError();
  }

  @override
  Future<bool> deleteCategory(String id) {
    // TODO: implement deleteCategory
    throw UnimplementedError();
  }

  @override
  Future<List<CategoryEntity>> getAllCategory() async {
    final list = await dataSource.getAll('category');
    List<CategoryEntity> data =
        list.map((map) => CategoryModel.fromMap(map)).toList();
    return data;
  }
}
