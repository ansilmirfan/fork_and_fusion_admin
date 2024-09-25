import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class EditProductUsecase {
  ProductRepo repo;
  EditProductUsecase(this.repo);
  Future<bool> call(String id, ProductEntity newData)async {
    return await repo.editProduct(id,newData );
  }
}
