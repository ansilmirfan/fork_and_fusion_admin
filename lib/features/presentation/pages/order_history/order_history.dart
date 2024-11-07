import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/all.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/today.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/drawer/custom_drawer.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/gap.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/tabbar/custom_tabbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/tabbar/tab_bar_item.dart';

class OrderHistory extends StatelessWidget {
  const OrderHistory({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Order history')),
        drawer: const CustomDrawer(),
        body: Column(
          children: [
            Gap(gap: 5),
            _tabbar(context),
            Expanded(
              child: TabBarView(
                children: [
                  const Today(),
                  All(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  CustomTabbar _tabbar(BuildContext context) {
    return const CustomTabbar(
        tabs: [TabBarItem(text: 'Today'), TabBarItem(text: 'All')]);
  }
}
