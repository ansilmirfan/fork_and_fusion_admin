import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class SearchProductUsecase {
  ProductRepo repo;
  SearchProductUsecase(this.repo);
  Future<List<ProductEntity>> call(String querry) async {
    return await repo.search(querry);
  }
}
