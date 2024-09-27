import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/core/utils/utils.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/product.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/product_management/product_management_bloc.dart';

import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_alert_dialog.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/image%20widgets/custome_circle_avathar.dart';

class ProductTile extends StatelessWidget {
  final ProductEntity data;
  bool search;
  ProductTile({super.key, required this.data, this.search = false});

  @override
  Widget build(BuildContext context) {
    final bloc = ProductManagementBloc();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: _buildListTile(context, bloc),
    );
  }

  Material _buildListTile(BuildContext context, ProductManagementBloc bloc) {
    return Material(
      elevation: 10,
      borderRadius: Constants.radius,
      child: ListTile(
        onTap: () {
          Navigator.of(context).pushNamed('/product view', arguments: data);
        },
        title: _titile(),
        subtitle: _price(),
        leading: _image(),
        trailing: _buildTrailingButton(context, bloc),
      ),
    );
  }

  Hero _image() {
    return Hero(
      tag: data.id,
      child: CustomeCircleAvathar(
        url: data.image,
        radius: 30,
      ),
    );
  }

  Text _price() {
    return data.price == 0
        ? Text("₹ ${data.variants.values.first}")
        : Text('₹ ${data.price}');
  }

  Text _titile() => Text(Utils.capitalizeEachWord(data.name));

  Row? _buildTrailingButton(BuildContext context, ProductManagementBloc bloc) {
    return search
        ? null
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/create product',
                        arguments: {'data': data, 'edit': true});
                  },
                  icon: const Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    showCustomAlertDialog(
                      context: context,
                      title: 'Confirm Deletion',
                      description:
                          'This action will permanently remove this item. Do you want to proceed?',
                      okbutton: _okButton(bloc),
                    );
                  },
                  icon: const Icon(Icons.delete))
            ],
          );
  }

  BlocConsumer _okButton(ProductManagementBloc bloc) {
    return BlocConsumer<ProductManagementBloc, ProductManagementState>(
      bloc: bloc,
      listener: (context, state) {
        if (state is ProductManagementDeleteCompletedState) {
          Navigator.of(context).pop();
          context
              .read<ProductManagementBloc>()
              .add(ProductManagementGetAllEvent());
        }
      },
      builder: (context, state) {
        if (state is ProductManagementLoadingState) {
          return const ElevatedButton(
              onPressed: null, child: CircularProgressIndicator());
        }
        return ElevatedButton(
          onPressed: () {
            bloc.add(ProductManagementDeleteEvent(data.id, data.image));
          },
          child: const Text('OK'),
        );
      },
    );
  }
}
