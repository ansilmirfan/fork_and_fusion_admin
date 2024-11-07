part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitialState extends OrderState {}

final class OrderLoadingState extends OrderState {}

final class OrderErrorState extends OrderState {
  String message;
  OrderErrorState(this.message);
}

final class OrderCompletedState extends OrderState {
  List<OrderEntity> orders;
  int overallSale;
  int todaysSale;
  int totalOrderCount;
  int todaysOrderCount;

  OrderCompletedState(
      {required this.orders,
      required this.overallSale,
      required this.todaysOrderCount,
      required this.todaysSale,
      required this.totalOrderCount});
}

final class OrderUpdateCompletedState extends OrderState {
  OrderEntity order;
  OrderUpdateCompletedState(this.order);
}
