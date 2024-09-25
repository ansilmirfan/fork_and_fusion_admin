
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/custome_circle_avathar.dart';


class ProductTile extends StatelessWidget {
  ProductEntity data;
  ProductTile({super.key, required this.data});
  var type = ProductType.values;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ProductManagementBloc>();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Dismissible(
        key: Key(data.name),
        background: Container(
          color: Colors.green,
          padding: const EdgeInsets.only(left: 30),
          alignment: Alignment.centerLeft,
          child: Icon(
            Icons.edit,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        secondaryBackground: Container(
          color: Theme.of(context).colorScheme.error,
          padding: const EdgeInsets.only(right: 30),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete,
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.startToEnd) {
            return false;
          }

          if (direction == DismissDirection.endToStart) {
            showCustomAlertDialog(
              context: context,
              title: Constants.deleteMessage.entries.first.key,
              description: Constants.deleteMessage.entries.first.value,
              okbutton: _okButton(),
            );
            return false;
          }
        },
        child: Stack(
          children: [
            Material(
              elevation: 10,
              borderRadius: Constants.radius,
              child: ListTile(
                title: Text(
                  Utils.capitalizeEachWord(data.name),
                ),
                leading: CustomeCircleAvathar(url: data.image),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BlocConsumer _okButton() {
    return BlocConsumer<ProductManagementBloc, ProductManagementState>(
      listener: (context, state) {
        if (state is ProductManagementCompletedState) {
         Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        if (state is ProductManagementLoadingState) {
          return const ElevatedButton(
              onPressed: null, child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: () {
            context
                .read<ProductManagementBloc>()
                .add(ProductManagementDeleteEvent(data.id, data.image));
          },
          child: const Text('OK'),
        );
      },
    );
  }
}
