// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/rich_label_text.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_view/widgets/order_listtile.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_view/widgets/order_status_popup.dart';


class OrderView extends StatelessWidget {
  OrderEntity order;
  OrderView({super.key, required this.order});
  final List<String> orderStatus = [
    'Processing',
    'Cooking',
    'Partial',
    'Served',
    'Cancelled'
  ];

  OrderBloc orderBloc = OrderBloc();
  @override
  Widget build(BuildContext context) {
    var children = [
      _subtotalText(context),
      _orderDetails(),
      _orderStatus(),
      ..._buildProductList(),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(order.paymentId)),
      body: BlocBuilder<OrderBloc, OrderState>(
        bloc: orderBloc,
        buildWhen: (previous, current) {
          return current != OrderLoadingState;
        },
    
        builder: (context, state) {
        
          if (state is OrderUpdateCompletedState) {
            order = state.order;
          }
          return ListView.builder(
            padding: Constants.padding10,
            itemCount: children.length,
            itemBuilder: (context, index) => children[index],
          );
        },
      ),
    );
  }

  Widget _orderStatus() {
    return Row(
      children: [
        const Text('Status   :   '),
        OrderStatusPopup(
          order: order,
          orderBloc: orderBloc,
          values: orderStatus,
          currentStatus: order.status,
        ),
      ],
    );
  }

  Column _orderDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichLabelText(text1: 'Order id :', text2: order.id),
        RichLabelText(text1: 'Payment id :', text2: order.paymentId),
        RichLabelText(text1: 'Table no:', text2: order.table),
        RichLabelText(text1: 'Name :', text2: order.user.userName),
        RichLabelText(text1: 'User id :', text2: order.user.userId),
        RichLabelText(text1: 'Date :', text2: Utils.formatDate(order.date)),
        RichLabelText(text1: 'Time :', text2: Utils.formatTime(order.date))
      ],
    );
  }

  List<Widget> _buildProductList() {
    return List.generate(
      order.products.length,
      (index) => OrderListtile(
        cart: order.products[index],
        order: order,
        index: index,
        orderBloc: orderBloc,
      ),
    );
  }

  Text _subtotalText(BuildContext context) {
    return Text('Subtotal ₹ ${order.amount}',
        style: Theme.of(context).textTheme.headlineMedium);
  }
}
