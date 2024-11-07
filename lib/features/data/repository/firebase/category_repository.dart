// ignore_for_file: prefer_typing_uninitialized_variables

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
  Future<bool> updateCategory(String id, CategoryEntity newData) async {
    final image;
    if (newData.file != null) {
      // await dataSource.deleteImage(newData.image);
      image = await dataSource.uploadImage(newData.file!, 'category');
      newData.image = image;
    }
    return await dataSource.edit(id, 'category', CategoryModel.toMap(newData));
  }

  @override
  Future<bool> deleteCategory(String id, String url) async {
    final isdeletable = await dataSource.isDeletable(
        collection: 'products', value: id, field: "category", array: true);
    if (!isdeletable) {
      throw "Category cannot be deleted, it's associated with existing products.";
    }
    // final result = await dataSource.deleteImage(url);
    // if (result) {
    //   return await dataSource.delete(id, 'category');
    // }
    throw 'Could not delete the image. something went wrong';
  }

  @override
  Future<List<CategoryEntity>> getAllCategory() async {
    final list = await dataSource.getAll('category');
    List<CategoryEntity> data =
        list.map((map) => CategoryModel.fromMap(map)).toList();
    return data;
  }

  @override
  Future<List<CategoryEntity>> search(String querry) async {
    final response = await dataSource.search('category', querry);
    final data = response.map((e) => CategoryModel.fromMap(e)).toList();
    return data;
  }
}
