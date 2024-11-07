// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/date_alert_dialog.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/history_list_tile.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/empty_message.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/loading.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/snackbar.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/square_icon_button.dart';

class All extends StatelessWidget {
  All({super.key});

  final gap = const SizedBox(height: 10);

  final ScrollController controller = ScrollController();

  Map<String, List<OrderEntity>> ordersMap = {};

  Map<String, GlobalKey> dateKeys = {};

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>();
    return RefreshIndicator(
      onRefresh: () async => context.read<OrderBloc>().add(OrderGetAllEvent()),
      child: BlocBuilder<OrderBloc, OrderState>(
        builder: (context, state) {
          if (state is OrderLoadingState) {
            return const Loading();
          }
          if (state is OrderCompletedState) {
            return _buildBody(context, state.orders);
          }
          return const EmptyMessage(message: 'Network Error');
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, List<OrderEntity> orders) {
    if (orders.isEmpty) {
      return const EmptyMessage(message: 'No orders yet');
    }

    final List<String> statuses = ['All', 'Served', 'Cancelled'];
    int selectedIndex = 0;

    return StatefulBuilder(
      builder: (context, setState) => Column(
        children: [
          gap,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(10.0),
              isSelected: List.generate(
                  statuses.length, (index) => index == selectedIndex),
              onPressed: (int index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              children: statuses
                  .map((status) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(status),
                      ))
                  .toList(),
            ),
          ),
          gap,
          Expanded(
            child: _filterOrdersByStatus(context, orders, selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _filterOrdersByStatus(
      BuildContext context, List<OrderEntity> orders, int selectedIndex) {
    List<OrderEntity> filteredOrders = [];
    if (selectedIndex == 0) {
      filteredOrders = orders;
    } else if (selectedIndex == 1) {
      filteredOrders =
          orders.where((order) => order.status == 'Served').toList();
    } else if (selectedIndex == 2) {
      filteredOrders =
          orders.where((order) => order.status == 'Cancelled').toList();
    }

    return _scrollBar(context, filteredOrders);
  }

  Widget _scrollBar(BuildContext context, List<OrderEntity> orders) {
    return Scrollbar(
      interactive: true,
      thumbVisibility: true,
      trackVisibility: true,
      controller: controller,
      thickness: 10,
      child: ListView(
        padding: Constants.padding10,
        controller: controller,
        children: [
          gap,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_subtotal(context, orders), _datePicker(context)],
          ),
          _listView(orders),
        ],
      ),
    );
  }

  Widget _listView(List<OrderEntity> orders) {
    ordersMap = convertToMap(orders);
    var keys = ordersMap.keys.toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: keys.length,
      itemBuilder: (context, index) {
        String dateKey = keys[index];
        var ordersForDate = ordersMap[dateKey] ?? [];
        dateKeys[dateKey] = GlobalKey();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDate(context, dateKey),
            Column(
              children: List.generate(
                ordersForDate.length,
                (i) => SizedBox(
                  width: double.infinity,
                  child: HistoryListTile(
                    order: ordersForDate[i],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Date divider
  Center _buildDate(BuildContext context, String dateKey) {
    return Center(
      key: dateKeys[dateKey],
      child: Container(
        margin: const EdgeInsets.only(bottom: 10, top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.inversePrimary,
          borderRadius: Constants.radius,
        ),
        child: Text(dateKey),
      ),
    );
  }

  // Date picker dialog
  SquareIconButton _datePicker(BuildContext context) {
    return SquareIconButton(
      icon: Icons.calendar_month,
      onTap: () async {
        DateTime? picked = await dateAlertDialog(context);
        if (picked != null) {
          String formattedDate = Utils.formatDate(picked);

          _scrollToDate(formattedDate, context);
        }
      },
    );
  }

  //------ Scroll to selected date
  void _scrollToDate(String date, BuildContext context) {
    if (dateKeys.containsKey(date)) {
      final key = dateKeys[date];
      final context = key?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    } else {
      showCustomSnackbar(
          context: context,
          message: "No Data found in selected date",
          isSuccess: false);
    }
  }

  // Subtotal amount
  Text _subtotal(BuildContext context, List<OrderEntity> orders) {
    var total = orders.map((e) => e.amount).reduce((a, b) => a + b);
    return Text(
      'Subtotal ₹$total',
      style: Theme.of(context).textTheme.headlineSmall,
    );
  }

  // Convert list to map by date
  Map<String, List<OrderEntity>> convertToMap(List<OrderEntity> orders) {
    Map<String, List<OrderEntity>> map = {};
    for (var element in orders) {
      var date = Utils.formatDate(element.date);
      map[date] ??= [];
      map[date]?.add(element);
    }
    return map;
  }
}
