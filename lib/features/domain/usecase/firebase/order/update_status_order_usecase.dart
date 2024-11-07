import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/order_repo.dart';

class UpdateStatusOrderUsecase {
  OrderRepo repo;
  UpdateStatusOrderUsecase(this.repo);
  Future<OrderEntity> call(
      bool product, OrderEntity order, String selected) async {
    return await repo.updateStatus(product, order, selected);
  }
}
