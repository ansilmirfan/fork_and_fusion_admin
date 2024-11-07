import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';

abstract class OrderRepo {
  Stream<List<OrderEntity>> getAllOrders();
  Future<OrderEntity> updateStatus(
      bool product, OrderEntity order, String selected);
  Future<bool> updateOrderPayment(Map<String, dynamic> map, String id);
}
