import 'package:fork_and_fusion_admin/features/data/repository/firebase/category_repository.dart';
import 'package:fork_and_fusion_admin/features/data/repository/firebase/product_repository.dart';
import 'package:fork_and_fusion_admin/features/data/repository/image_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/image_repo/image_repo.dart';

class Services {
  static CategoryRepo categoryRepo() => CategoryRepository();
  static ImageRepo imageRepo() => ImageRepository();
  static ProductRepo productRepo() => ProductRepository();
}
