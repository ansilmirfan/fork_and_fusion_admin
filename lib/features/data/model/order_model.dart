import 'package:fork_and_fusion_admin/features/data/model/cart_model.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/cart_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/user_entity.dart';

class OrderModel extends OrderEntity {
  OrderModel(
      {required super.id,
      required super.user,
      required super.paymentId,
      required super.amount,
      required super.date,
      required super.table,
      required super.products,
      super.repaid,
      super.status});
  factory OrderModel.fromMap(
      Map<String, dynamic> map, List<CartEntity> carts, UserEntity user) {
    return OrderModel(
        id: map['id'] ?? '',
        table: map['table'] ?? '',
        user: user,
        paymentId: map['payment id'] ?? '',
        amount: map['amount'] ?? 0,
        date: DateTime.parse(map['date']),
        products: carts,
        repaid: map['repaid'] ?? false,
        status: map['status']);
  }
  static Map<String, dynamic> toMap(OrderEntity order) {
    return {
      'id': order.id,
      'customer id': order.user.userId,
      'payment id': order.paymentId,
      'date': order.date.toString(),
      'amount': order.amount,
      'status': order.status,
      'table': order.table,
      'repaid':order.repaid,
          'items': cartToListOfMap(order.products)
    };
  }

  static List<Map<String, dynamic>> cartToListOfMap(List<CartEntity> carts) {
    return carts.map((element) {
      return CartModel.toMapWhole(element);
    }).toList();
  }
}
