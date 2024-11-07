part of 'order_bloc.dart';

@immutable
sealed class OrderEvent {}

final class OrderGetAllEvent extends OrderEvent {}

final class OrderStatusUpdateEvent extends OrderEvent {
  bool product;
  OrderEntity order;
  String selected;
  OrderStatusUpdateEvent(
      {required this.order, required this.selected, this.product = false});
}

final class OrderPaymentStatusEvent extends OrderEvent {
  String id;
  OrderPaymentStatusEvent(this.id);
}
