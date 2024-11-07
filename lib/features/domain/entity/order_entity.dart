import 'package:fork_and_fusion_admin/features/domain/entity/cart_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/user_entity.dart';

class OrderEntity {
  String id;
  String paymentId;
  num amount;
  List<CartEntity> products;
  String status;
  DateTime date;
  String table;
  UserEntity user;
  bool repaid;
  OrderEntity(
      {required this.id,
      required this.paymentId,
      required this.amount,
      required this.products,
      required this.user,
      required this.table,
      required this.date,
      this.repaid=false,
      this.status = 'processing'});
}
