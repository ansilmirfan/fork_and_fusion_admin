// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/history_list_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/empty_message.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/loading.dart';

class Repayment extends StatelessWidget {
  const Repayment({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>();
    return Scaffold(
      drawer: const CustomDrawer(),
      appBar: AppBar(title: const Text('Repayment')),
      body: BlocBuilder<OrderBloc, OrderState>(
        buildWhen: (previous, current) => current != OrderLoadingState,
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Loading();
          }
          if (state is OrderCompletedState) {
            //-----------filter by cancelled and not repaid--------------
            List<OrderEntity> orders = state.orders
                .where((e) => !e.repaid && e.status == 'Cancelled')
                .toList();
            if (orders.isEmpty) {
              return const EmptyMessage(
                  message: 'No Repayment Pendings All are upto date');
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
      itemBuilder: (context, index) => HistoryListTile(
        order: orders[index],
        fromRepayment: true,
      ),
    );
  }
}
