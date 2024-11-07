import 'dart:developer';

import 'package:fork_and_fusion_admin/features/data/data_source/firebase/firebase_services.dart';
import 'package:fork_and_fusion_admin/features/data/model/cart_model.dart';
import 'package:fork_and_fusion_admin/features/data/model/category_model.dart';
import 'package:fork_and_fusion_admin/features/data/model/order_model.dart';
import 'package:fork_and_fusion_admin/features/data/model/product_model.dart';
import 'package:fork_and_fusion_admin/features/data/model/user_model.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/cart_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/domain/repository/firebase/order_repo.dart';

class OrderRepository implements OrderRepo {
  final FirebaseServices _dataSource = FirebaseServices();

  final String collection = 'orders';

  //------------------get all orders------------------
  @override
  Stream<List<OrderEntity>> getAllOrders() async* {
    final dataStream = _dataSource.featchAll(collection);

    await for (var snapshot in dataStream) {
      List<OrderEntity> orders = [];

      for (var map in snapshot) {
        final items = List<Map<String, dynamic>>.from(map['items'] ?? []);

        List<CartEntity> carts = items.map((cartMap) {
          final Map<String, dynamic> productMap = cartMap['product']['product'];

          final List<Map<String, dynamic>> categoryMaps =
              List<Map<String, dynamic>>.from(
                  cartMap['product']['categories'] ?? []);

          List<CategoryEntity> categories = categoryMaps
              .map((element) => CategoryModel.fromMap(element))
              .toList();

          ProductEntity product = ProductModel.fromMap(productMap, categories);

          return CartModel.fromMap(cartMap, product);
        }).toList();
        final userId = map['customer id'];
        final user = await _dataSource.getOne('user', userId);
        orders.add(OrderModel.fromMap(map, carts, UserModel.fromMap(user)));
      }
      log(orders.length.toString());

      yield orders;
    }
  }

//------------------status updating-----------------
  @override
  Future<OrderEntity> updateStatus(
      bool product, OrderEntity order, String selected) async {
    if (product) {
      await _dataSource.edit(order.id, collection, OrderModel.toMap(order));
    } else {
      if (selected == 'Cancelled') {
        for (var element in order.products) {
          element.status = 'Cancelled';
        }
      }
      await _dataSource.edit(order.id, collection, {'status': selected});
    }
    final data = await _dataSource.getOne(collection, order.id);
    final user = await _dataSource.getOne('user', data['customer id']);
    final items = List<Map<String, dynamic>>.from(data['items'] ?? []);

    List<CartEntity> carts = items.map((cartMap) {
      final Map<String, dynamic> productMap = cartMap['product']['product'];

      final List<Map<String, dynamic>> categoryMaps =
          List<Map<String, dynamic>>.from(
              cartMap['product']['categories'] ?? []);

      List<CategoryEntity> categories = categoryMaps
          .map((element) => CategoryModel.fromMap(element))
          .toList();

      ProductEntity product = ProductModel.fromMap(productMap, categories);

      return CartModel.fromMap(cartMap, product);
    }).toList();

    return OrderModel.fromMap(data, carts, UserModel.fromMap(user));
  }

  @override
  Future<bool> updateOrderPayment(Map<String, dynamic> map, String id) async {
    return _dataSource.edit(id, collection, map);
  }
}
