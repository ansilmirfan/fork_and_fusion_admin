import 'package:fork_and_fusion_admin/features/data/repository/firebase/category_repository.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/category_repo.dart';

class Services {
  static CategoryRepo categoryRepo() => CategoryRepository();
}
