import 'dart:io';

class CategoryEntity {
  String name;
  String image;
  String id;
  File? file;
  CategoryEntity(
      {required this.name, required this.image, required this.id, this.file});
}
