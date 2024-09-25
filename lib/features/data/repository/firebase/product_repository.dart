// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
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
    final image = await dataSource.uploadImage(data.file!, collection);
    data.image = image;

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
    final image;
    if (newData.file != null) {
      await dataSource.deleteImage(newData.image);
      image = await dataSource.uploadImage(newData.file!, collection);
      newData.image = image;
    }
    return await dataSource.edit(id, collection, ProductModel.toMap(newData));
  }

  @override
  Future<bool> deleteProduct(String id, String url) async {
    final result = await dataSource.deleteImage(url);
    if (result) {
      return await dataSource.delete(id, collection);
    }
    throw 'Could not delete the image. something went wrong';
  }

  @override
  Future<List<ProductEntity>> search(String querry) async {
    final list = await dataSource.search(collection, querry);
    List<Future<ProductEntity>> future = list.map((map) async {
      List<String> c = map['category'];

      List<CategoryEntity> category = await Future.wait(c.map((e) async {
        final data = await dataSource.getOne('category', e);
        return CategoryModel.fromMap(data);
      }).toList());

      return ProductModel.fromMap(map, category);
    }).toList();

    return await Future.wait(future);
  }


}
