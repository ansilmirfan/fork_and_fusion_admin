import 'package:flutter/material.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/cart_entity.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/order_entity.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/order_bloc/order_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/order_view/widgets/order_status_popup.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/elevated_container.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/gap.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/cached_image.dart';

class OrderListtile extends StatelessWidget {
  final CartEntity cart;
  final OrderEntity order;
  final OrderBloc orderBloc;
  int index;
  OrderListtile(
      {super.key,
      required this.cart,
      required this.order,
      required this.index,
      required this.orderBloc});
  final List<String> productStatus = [
    'Processing',
    'Cooking',
    'Served',
    'Cancelled'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: ElevatedContainer(
        child: SizedBox(
          height: Constants.dHeight * .20,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              children: [
                _image(),
                Gap.width(8),
                _productDetails(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Expanded _productDetails(BuildContext context) {
    return Expanded(
      child: SizedBox(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _text(cart.product.name),
              _visibilityText(
                  context, cart.selectedType, cart.selectedType.isNotEmpty),
              Wrap(
                spacing: 10,
                children: [
                  _text(Utils.calculateOffer(cart.product, cart.selectedType)
                      .toString()),
                  _text("X ${cart.quantity}"),
                ],
              ),
              _visibilityText(context, 'Parcel', cart.parcel),
              SingleChildScrollView(
                child: _visibilityText(context, cart.cookingRequest,
                    cart.cookingRequest.isNotEmpty),
              ),
              Gap(gap: 5),
              Row(
                children: [
                  OrderStatusPopup(
                    fromProduct: true,
                    order: order,
                    orderBloc: orderBloc,
                    values: productStatus,
                    currentStatus: cart.status,
                    index: index,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  _text(String text) => Text(Utils.capitalizeEachWord(text));
  Visibility _visibilityText(
          BuildContext context, String text, bool visibility) =>
      Visibility(
        visible: visibility,
        child: Text(
          text,
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
      );
  Expanded _image() {
    return Expanded(
      child: SizedBox(
        height: double.infinity,
        child: ClipRRect(
          borderRadius: Constants.radius,
          child: CachedImage(
            url: cart.product.image.first,
          ),
        ),
      ),
    );
  }
}
