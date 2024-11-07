// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/elevated_container.dart';

class OrderStatusPopup extends StatefulWidget {
  String currentStatus;
  List<String> values;
  bool fromProduct;
  OrderEntity order;
  OrderBloc orderBloc;
  int index;

  OrderStatusPopup(
      {super.key,
      required this.values,
      required this.currentStatus,
      required this.orderBloc,
      required this.order,
      this.fromProduct = false,
      this.index = 0});

  @override
  _OrderStatusPopupState createState() => _OrderStatusPopupState();
}

class _OrderStatusPopupState extends State<OrderStatusPopup> {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      position: PopupMenuPosition.under,
      onSelected: (value) {
        setState(() {
          widget.currentStatus = value;
        });
        if (widget.fromProduct) {
          widget.order.products[widget.index].status = value;
        }
        widget.orderBloc.add(OrderStatusUpdateEvent(
            order: widget.order, selected: value, product: widget.fromProduct));
      },
      itemBuilder: (context) => [
        ...List.generate(
          widget.values.length,
          (index) => PopupMenuItem(
            value: widget.values[index],
            child: Text(widget.values[index]),
          ),
        )
      ],
      child: ElevatedContainer(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                widget.currentStatus,
                style: TextStyle(
                    color: widget.currentStatus == 'Cancelled'
                        ? Theme.of(context).colorScheme.error
                        : null),
              ),
              const Icon(Icons.arrow_drop_down)
            ],
          ),
        ),
      ),
    );
  }
}
