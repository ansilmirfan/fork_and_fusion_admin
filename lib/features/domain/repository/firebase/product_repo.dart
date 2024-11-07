import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';

abstract class ProductRepo {
  Future<void> createProduct(ProductEntity data);
  Future<List<ProductEntity>> getAllProducts();
  Future<bool> deleteProduct(String id, List<String> url);
  Future<bool> editProduct(String id, ProductEntity newData);
  Future<List<ProductEntity>> search(String querry);
}
