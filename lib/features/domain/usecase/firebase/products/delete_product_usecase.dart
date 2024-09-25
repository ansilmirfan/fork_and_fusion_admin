import 'package:fork_and_fusion_admin/features/domain/repository/firebase/product_repo.dart';

class DeleteProductUsecase {
  ProductRepo repo;
  DeleteProductUsecase(this.repo);
  Future<bool> call(String id, String url) async {
    return await repo.deleteProduct(id, url);
  }
}
