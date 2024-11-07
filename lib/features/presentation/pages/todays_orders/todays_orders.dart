import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/history_list_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/empty_message.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/gap.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/loading.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/tabbar/custom_tabbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/tabbar/tab_bar_item.dart';

class TodaysOrders extends StatelessWidget {
  TodaysOrders({super.key});
  final List<String> orderStatus = [
    'All',
    'Processing',
    'Cooking',
    'Partial',
    'Served',
    'Cancelled'
  ];

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>();
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(title: const Text("Today's order")),
        drawer: const CustomDrawer(),
        body: RefreshIndicator(
          onRefresh: () async =>
              context.read<OrderBloc>().add(OrderGetAllEvent()),
          child: BlocBuilder<OrderBloc, OrderState>(
            builder: (context, state) {
              if (state is OrderLoadingState) {
                return const Loading();
              }
              if (state is OrderCompletedState) {
                List<OrderEntity> orders = state.orders
                    .where((e) => Utils.isToday(e.date))
                    .toList()
                    .reversed
                    .toList();
                if (orders.isEmpty) {
                  return const EmptyMessage(message: "No Orders today!");
                }
                return _buildBody(orders);
              }
              return const EmptyMessage(message: 'Network Error');
            },
          ),
        ),
      ),
    );
  }

  Column _buildBody(List<OrderEntity> orders) {
    return Column(
      children: [
        Gap(gap: 5),
        CustomTabbar(
            isScrollable: true,
            tabs: List.generate(
              orderStatus.length,
              (index) => TabBarItem(text: orderStatus[index]),
            )),
        Expanded(
          child: TabBarView(
              children: List.generate(
            6,
            (index) => _listView(orders, index),
          )),
        )
      ],
    );
  }

  _listView(List<OrderEntity> orders, int index) {
    if (index != 0) {
      orders = orders.where((e) => e.status == orderStatus[index]).toList();
    }
    if (orders.isEmpty) {
      return EmptyMessage(message: 'No Orders in ${orderStatus[index]}');
    }

    return ListView.builder(
      padding: Constants.padding10,
      itemCount: orders.length,
      itemBuilder: (context, index) => HistoryListTile(order: orders[index]),
    );
  }
}
