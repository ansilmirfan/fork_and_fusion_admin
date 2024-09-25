import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class CreateProductUsecase {
  ProductRepo repo;
  CreateProductUsecase(this.repo);
  Future<void> call(ProductEntity data) async {
    await repo.createProduct(data);
  }
}
