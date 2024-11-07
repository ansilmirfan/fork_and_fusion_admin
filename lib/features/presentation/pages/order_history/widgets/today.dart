import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/history_list_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/empty_message.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/loading.dart';

class Today extends StatelessWidget {
  const Today({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => context.read<OrderBloc>().add(OrderGetAllEvent()),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Loading();
          } else if (state is OrderCompletedState) {
            List<OrderEntity> orders = state.orders
                .where((e) => Utils.isToday(e.date))
                .toList()
                .reversed
                .toList();
            if (orders.isEmpty) {
              return const EmptyMessage(message: 'No Orders yet');
            }
            return _listView(orders);
          }
          return const EmptyMessage(message: 'Network Error');
        },
      ),
    );
  }

  ListView _listView(List<OrderEntity> orders) {
    return ListView.builder(
      padding: Constants.padding10,
      itemCount: orders.length,
      itemBuilder: (context, index) => HistoryListTile(order: orders[index]),
    );
  }
}
