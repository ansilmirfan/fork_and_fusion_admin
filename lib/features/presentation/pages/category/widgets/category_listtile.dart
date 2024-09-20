// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fork_and_fusion_admin/core/shared/constants.dart';
import 'package:fork_and_fusion_admin/features/domain/entity/category.dart';
import 'package:fork_and_fusion_admin/features/presentation/bloc/category_managemnt/category_management_bloc.dart';

import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_bottom_sheet.dart';
import 'package:fork_and_fusion_admin/features/presentation/pages/category/widgets/category_view.dart';
import 'package:fork_and_fusion_admin/features/presentation/widgets/custom_alert_dialog.dart';

class CategoryListtile extends StatelessWidget {
  CategoryEntity data;
  CategoryListtile({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    context.read<CategoryManagementBloc>();
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Hero(
        tag: data.name,
        child: Material(
          borderRadius: Constants.radius,
          elevation: 10,
          child: ListTile(
            onTap: () => onTap(context),
            leading: _buildImage(),
            title: Text(data.name),
            trailing: _buildEditDeleteButton(context),
          ),
        ),
      ),
    );
  }

  Row _buildEditDeleteButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
            onPressed: () {
              categoryBottomSheet(context, edit: true, data: data);
            },
            icon: const Icon(Icons.edit)),
        IconButton(
          onPressed: () {
            showCustomAlertDialog(
              context: context,
              title: 'Confirm Deletion',
              description:
                  'This action will permanently remove this item. Do you want to proceed?',
              onPressed: () async {
                context
                    .read<CategoryManagementBloc>()
                    .add(CategoryManagementDeleteEvent(data.id, data.image));
              },
            );
          },
          icon: const Icon(Icons.delete),
        )
      ],
    );
  }

  CircleAvatar _buildImage() {
    return CircleAvatar(
      backgroundImage: CachedNetworkImageProvider(data.image),
    );
  }

  void onTap(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 600),
      opaque: false,
      pageBuilder: (context, animation, secondaryAnimation) =>
          CategoryView(data: data),
    ));
  }
}
