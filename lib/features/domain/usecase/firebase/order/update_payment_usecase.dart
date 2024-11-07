

import 'package:fork_and_fusion_admin/features/domain/repository/firebase/order_repo.dart';

class UpdatePaymentUsecase {
  OrderRepo repo;
  UpdatePaymentUsecase(this.repo);
  Future<bool> call(Map<String, dynamic> map, String id) async {
    return await repo.updateOrderPayment(map, id);
  }
}
