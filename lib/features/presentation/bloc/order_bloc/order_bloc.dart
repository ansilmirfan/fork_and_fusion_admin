import 'dart:async';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:fork_and_fusion_admin/core/services/services.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/order/get_all_order_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/order/update_payment_usecase.dart';
import 'package:fork_and_fusion_admin/features/domain/usecase/firebase/order/update_status_order_usecase.dart';

import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitialState()) {
    on<OrderGetAllEvent>(orderGetAllEvent);
    on<OrderStatusUpdateEvent>(orderStatusUpdateEvent);
    on<OrderPaymentStatusEvent>(orderPaymentStatusEvent);
  }

  FutureOr<void> orderGetAllEvent(
      OrderGetAllEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    GetAllOrderUsecase usecase = GetAllOrderUsecase(Services.orderRepo());
    await emit.forEach(
      usecase.call(),
      onData: (data) {
        data.sort((a, b) => b.date.compareTo(a.date));
        int totalSale = calculateAmont(data, false, false);
        int totalCount = calculateAmont(data, false, true);
        int todaysSale = calculateAmont(data, true, false);
        int todaysCount = calculateAmont(data, true, true);

        return OrderCompletedState(
            orders: data,
            overallSale: totalSale,
            todaysOrderCount: todaysCount,
            todaysSale: todaysSale,
            totalOrderCount: totalCount);
      },
      onError: (error, stackTrace) {
        log(error.toString());
        return OrderErrorState('Network error');
      },
    );
  }

  FutureOr<void> orderStatusUpdateEvent(
      OrderStatusUpdateEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      UpdateStatusOrderUsecase usecase =
          UpdateStatusOrderUsecase(Services.orderRepo());
      final result =
          await usecase.call(event.product, event.order, event.selected);
      emit(OrderUpdateCompletedState(result));
    } catch (e) {
      emit(OrderErrorState('Network error'));
    }
  }

  FutureOr<void> orderPaymentStatusEvent(
      OrderPaymentStatusEvent event, Emitter<OrderState> emit) async {
    emit(OrderLoadingState());
    try {
      UpdatePaymentUsecase usecase = UpdatePaymentUsecase(Services.orderRepo());

      await usecase.call({'repaid': true}, event.id);
      add(OrderGetAllEvent());
    } catch (e) {
      emit(OrderErrorState('Network error'));
    }
  }
  //--------function for calculation--------------------
  //---total sale amount--total sale count----today's sale count and amount--------

  int calculateAmont(List<OrderEntity> orders, bool today, bool count) {
    if (orders.isEmpty) {
      return 0;
    }

    final filteredOrders = today
        ? orders
            .where((e) => e.status == 'Served' && Utils.isToday(e.date))
            .toList()
        : orders.where((e) => e.status == 'Served').toList();

    if (filteredOrders.isEmpty) {
      return 0;
    }
    if (count) {
      return filteredOrders.length;
    }

    return filteredOrders.map((e) => e.amount).reduce((a, b) => a + b).toInt();
  }
}
