// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:fork_and_fusion_admin/features/data/data_source/firebase/firebase_services.dart';
import 'package:fork_and_fusion_admin/features/data/model/category_model.dart';
import 'package:fork_and_fusion_admin/features/data/model/product_model.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class ProductRepository extends ProductRepo {
  FirebaseServices dataSource = FirebaseServices();
  var collection = 'products';
  @override
  Future<void> createProduct(ProductEntity data) async {
    List<String> images = [];
    for (var image in data.file!) {
      final link = await dataSource.uploadImage(image!, collection);
      images.add(link);
    }

    data.image = images;

    await dataSource.create(collection, ProductModel.toMap(data));
  }

  @override
  Future<List<ProductEntity>> getAllProducts() async {
    final list = await dataSource.getAll(collection);

    List<Future<ProductEntity>> futures = list.map((map) async {
      List c = map['category'];

      List<CategoryEntity> category = await Future.wait(c.map((e) async {
        final data = await dataSource.getOne('category', e);
        return CategoryModel.fromMap(data);
      }));

      return ProductModel.fromMap(map, category);
    }).toList();

    return await Future.wait(futures);
  }

  @override
  Future<bool> editProduct(String id, ProductEntity newData) async {
    final images = <String>[];
    if (newData.file != null) {
      // //----deleting images--------------
      // for (var image in newData.image) {
      //   await dataSource.deleteImage(image);
      // }
      for (var image in newData.file!) {
        images.add(await dataSource.uploadImage(image!, collection));
      }

      newData.image = images;
    }
    return await dataSource.edit(id, collection, ProductModel.toMap(newData));
  }

  @override
  Future<bool> deleteProduct(String id, List<String> url) async {
    // for (var image in url) {
    //   result = await dataSource.deleteImage(image);
    // }
    final isDeletable = await dataSource.isDeletable(
        collection: 'cart data', value: id, field: 'product', array: false);

    if (isDeletable) {
      return await dataSource.delete(id, collection);
    } else {
      throw 'Product cannot be deleted. It is associated with another field';
    }
  }

  @override
  Future<List<ProductEntity>> search(String querry) async {
    final list = await dataSource.search(collection, querry);
    List<Future<ProductEntity>> future = list.map((map) async {
      List c = map['category'];

      List<CategoryEntity> category = await Future.wait(c.map((e) async {
        final data = await dataSource.getOne('category', e);
        return CategoryModel.fromMap(data);
      }));

      return ProductModel.fromMap(map, category);
    }).toList();

    return await Future.wait(future);
  }
}
