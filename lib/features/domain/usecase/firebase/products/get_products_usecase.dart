import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class GetProductsUsecase {
  ProductRepo repo;
  GetProductsUsecase(this.repo);
  Future<List<ProductEntity>> call() async {
    return await repo.getAllProducts();
  }
}
