
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_history/widgets/rich_label_text.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/elevated_container.dart';

class HistoryListTile extends StatelessWidget {
  OrderEntity order;
  bool fromRepayment;
  HistoryListTile({super.key, required this.order, this.fromRepayment = false});
  final currentTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedContainer(
        child: InkWell(
          borderRadius: Constants.radius,
          onTap: () =>
              Navigator.of(context).pushNamed('/orderview', arguments: order),
          child: Container(
            padding: Constants.padding10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Order id:${order.id}'),
                    _orderStatus(),
                    _time(),
                  ],
                ),
                Visibility(
                  visible: fromRepayment,
                  child: Switch(
                    value: order.repaid,
                    onChanged: (value) => context.read<OrderBloc>().add(OrderPaymentStatusEvent(order.id)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  RichLabelText _orderStatus() {
    return RichLabelText(
      text1: 'Status:',
      text2: order.status,
    );
  }

  RichLabelText _time() {
    return RichLabelText(
        text1: 'Order Time:', text2: Utils.formatTime(order.date));
  }
}
