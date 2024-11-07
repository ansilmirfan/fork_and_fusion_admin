import 'dart:io';

import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';

class ProductEntity {
  String id;
  String name;
  num price;
  List<String> image;
  Map<String, dynamic> variants;
  List<File?>? file;
  String ingredients;
  int offer;
  List<ProductType> type;
  List<CategoryEntity> category;
  List<num> rating;
  ProductEntity({
    required this.id,
    required this.name,
    required this.image,
    required this.ingredients,
    this.price = 0,
    this.offer = 0,
    required this.category,
    this.type = const [],
    this.variants = const {},
    this.rating=const [],
    this.file,
  });
}
